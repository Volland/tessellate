// @flow

import fs from 'fs';
import path from 'path';
import nconf from 'nconf';
import yaml from 'js-yaml';
import logger from './logger';

const log = logger('nconf');

function readYamlFile(file: string): Object {
  try {
    return yaml.safeLoad(fs.readFileSync(file, 'utf8'));
  } catch (e) {
    log.warn(`Unable to load ${file}`);
    return {};
  }
}

const configFile = path.resolve(process.cwd(), 'config.yaml');

export default nconf
  .use('memory')
  .argv()
  .env()
  .add('config', { type: 'literal', store: readYamlFile(configFile) })
  .defaults({
    APP_PORT: 3004,
    MORGAN_FORMAT: 'dev',
    MORGAN_THRESHOLD: 0,
    BUNDLE_TARGET: 'http://localhost:3001/bundles'
  });
