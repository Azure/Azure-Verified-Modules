
// ============== //
//   Parameters   //
// ============== //

import { lockType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. The lock settings of the service.')
param lock lockType?

// ============= //
//   Resources   //
// ============= //

resource >singularMainResourceType<_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: >singularMainResourceType<
}
