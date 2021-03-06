#!/bin/bash


CURRDIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
ESS_ROOT=`echo $CURRDIR | awk -F'api' '{print $(NF-1)}'`'ess'
#ESS_ROOT='/cvpath-ess'

ESS_DIR="${ESS_ROOT}"

ESS_DIR_COMMON=${ESS_DIR}'/common'
ESS_DIR_USER=${ESS_DIR}'/'${uid}
[ "$uid" = '' -o  "$uid" = 'common' ] && { echo 'done'; exit; }  # just in case
CALC_BACKWARD_DAYS=0
ESS_IMPORT=${ESS_DIR_USER}'/import.sh'
DEFAULT_DATA_PATH=${ESS_DIR_USER}'/usrparam.csv'
ESS_DIR_COMMON_RELA=${ESS_DIR_USER}'/../common'
ESS_SET_INSTANCE=${ESS_DIR_COMMON_RELA}'/setupinstance.sh'
ESS_TERMINATE_INSTANCE=${ESS_DIR_COMMON_RELA}'/terminateinstance.sh'


deffiles(){
[ -e "${ESS_DIR_USER}/createdb.sh" ] && ESS_CREATEDB="${ESS_DIR_USER}/createdb.sh" || ESS_CREATEDB=${ESS_DIR_COMMON_RELA}'/createdb.sh'
[ -e "${ESS_DIR_USER}/setup.sh" ] && ESS_DATASTORE="${ESS_DIR_USER}/setup.sh" 
[ -e "${ESS_DIR_USER}/sizmek_match.sh" ] && ESS_CREATEMATCH="${ESS_DIR_USER}/sizmek_match.sh" || ESS_CREATEMATCH=${ESS_DIR_COMMON_RELA}'/sizmek_match.sh'
[ -e "${ESS_DIR_USER}/profile.sh" ] && ESS_PROFILE="${ESS_DIR_USER}/profile.sh" || ESS_PROFILE=${ESS_DIR_COMMON_RELA}'/profile.sh'
[ -e "${ESS_DIR_USER}/cal_path.sh" ] && ESS_CALPATH="${ESS_DIR_USER}/cal_path.sh" || ESS_CALPATH=${ESS_DIR_COMMON_RELA}'/cal_path.sh'
[ -e "${ESS_DIR_USER}/rev_path.sh" ] && ESS_CALPATH_REVERSE="${ESS_DIR_USER}/rev_path.sh" || ESS_CALPATH_REVERSE=${ESS_DIR_COMMON_RELA}'/rev_path.sh'
[ -e "${ESS_DIR_USER}/summary.sh" ] && ESS_QUERY_SUMMARY="${ESS_DIR_USER}/summary.sh" || ESS_QUERY_SUMMARY=${ESS_DIR_COMMON_RELA}'/summary.sh'
[ -e "${ESS_DIR_USER}/overall_ad_web.sh" ] && ESS_QUERY_OVERALL_AD_WEB="${ESS_DIR_USER}/overall_ad_web.sh" || ESS_QUERY_OVERALL_AD_WEB=${ESS_DIR_COMMON_RELA}'/overall_ad_web.sh'
[ -e "${ESS_DIR_USER}/overall_web.sh" ] && ESS_QUERY_OVERALL_WEB="${ESS_DIR_USER}/overall_web.sh" || ESS_QUERY_OVERALL_WEB=${ESS_DIR_COMMON_RELA}'/overall_web.sh'
[ -e "${ESS_DIR_USER}/depth.sh" ] && ESS_QUERY_DIST_FREQ="${ESS_DIR_USER}/depth.sh" || ESS_QUERY_DIST_FREQ=${ESS_DIR_COMMON_RELA}'/depth.sh'
[ -e "${ESS_DIR_USER}/pv_dist.sh" ] && ESS_QUERY_DIST_PV="${ESS_DIR_USER}/pv_dist.sh" || ESS_QUERY_DIST_PV=${ESS_DIR_COMMON_RELA}'/pv_dist.sh'
[ -e "${ESS_DIR_USER}/aggr_path.sh" ] && ESS_PATH="${ESS_DIR_USER}/aggr_path.sh" || ESS_PATH=${ESS_DIR_COMMON_RELA}'/aggr_path.sh'
[ -e "${ESS_DIR_USER}/aggr_rev_path.sh" ] && ESS_PATH_REVERSE="${ESS_DIR_USER}/aggr_rev_path.sh" || ESS_PATH_REVERSE=${ESS_DIR_COMMON_RELA}'/aggr_rev_path.sh'
[ -e "${ESS_DIR_USER}/seg_bw.sh" ] && ESS_PATH_DETAIL_BW="${ESS_DIR_USER}/seg_bw.sh" || ESS_PATH_DETAIL_BW=${ESS_DIR_COMMON_RELA}'/seg_bw.sh'
[ -e "${ESS_DIR_USER}/seg_rgn.sh" ] && ESS_PATH_REGION_MAP="${ESS_DIR_USER}/seg_rgn.sh" || ESS_PATH_REGION_MAP=${ESS_DIR_COMMON_RELA}'/seg_rgn.sh'
[ -e "${ESS_DIR_USER}/attribution.sh" ] && ESS_PATH_ATTRIBUTION_SCORE="${ESS_DIR_USER}/attribution.sh" || ESS_PATH_ATTRIBUTION_SCORE=${ESS_DIR_COMMON_RELA}'/attribution.sh'
[ -e "${ESS_DIR_USER}/seg_dump.sh" ] && ESS_PATH_DETAIL_DUMP="${ESS_DIR_USER}/seg_dump.sh" || ESS_PATH_DETAIL_DUMP=${ESS_DIR_COMMON_RELA}'/seg_dump.sh'
[ -e "${ESS_DIR_USER}/rank.sh" ] && ESS_PATH_BEFOREAFTER="${ESS_DIR_USER}/rank.sh" || ESS_PATH_BEFOREAFTER=${ESS_DIR_COMMON_RELA}'/rank.sh'
[ -e "${ESS_DIR_USER}/trend.sh" ] && ESS_TREND="${ESS_DIR_USER}/trend.sh" || ESS_TREND=${ESS_DIR_COMMON_RELA}'/trend.sh'
[ -e "${ESS_DIR_USER}/event.sh" ] && ESS_EVENT="${ESS_DIR_USER}/event.sh" || ESS_EVENT=${ESS_DIR_COMMON_RELA}'/event.sh'
#ESS_DATE_CHECK="${ESS_DIR_USER}/returnAvailableLogMaxDate.sh"

APACHE_DIR=${ESS_DIR_USER}'/.gui'
ESS_INSTANCE_STATUS=${APACHE_DIR}'/STATUSINSTANCE'
ESS_INSTANCE_TYPE=${APACHE_DIR}'/INSTANCETYPE'
ESS_INSTANCE_NUM=${APACHE_DIR}'/INSTANCENUMBER'
ESS_INSTANCE_START_TIME=${APACHE_DIR}'/STARTTIMEINSTANCE'
ESS_IMPORTED_PERIOD_F=${APACHE_DIR}'/IMPPERIODFROM'
ESS_IMPORTED_PERIOD_T=${APACHE_DIR}'/IMPPERIODTO'
ESS_IMPORTED_BACK_DAYS=${APACHE_DIR}'/IMPBACKDAYS'
ESS_IMPORTED_SAMPLING=${APACHE_DIR}'/IMPSAMPLING'
ESS_IMPORTED_MEMO=${APACHE_DIR}'/IMPMEMO'
ESS_IMPORTED_SEGMENT=${APACHE_DIR}'/IMPSEGMENT'
ESS_IMPORTED_CV=${APACHE_DIR}'/IMPCV'
ESS_IMPORTED_INTSPEC=${APACHE_DIR}'/IMPINTSPEC'
ESS_IMPORTED_INTSPEC_TEMP=${APACHE_DIR}'/IMPINTSPECTEMP'
ESS_IMPORTED_FILTER=${APACHE_DIR}'/IMPFILTEROPT'
ESS_IMPORTED_TOUCHPOINTDEF=${APACHE_DIR}'/IMPTOUCHPOINTDEF'
ESS_IMPORTED_TOUCHPOINTDEF_TEMP=${APACHE_DIR}'/IMPTOUCHPOINTDEFTEMP'
ESS_IMPORTED_TOUCHPOINTGROUPING=${APACHE_DIR}'/IMPTOUCHPOINTGROUPING'
ESS_IMPORTED_TOUCHPOINTGROUPING_TEMP=${APACHE_DIR}'/IMPTOUCHPOINTGROUPINGTEMP'
ESS_IMPORTED_USERSEGMENT=${APACHE_DIR}'/IMPUSERSEGMENT'
ESS_IMPORTED_CALPATH_ORDER=${APACHE_DIR}'/IMPCALPATHORDER' # 0: forward ... 1: ...reverse
IMPCALPATHTILLCVFLG=${APACHE_DIR}'/IMPCALPATHTILLCVFLG' # 1: to cv ... 0: ... to end ( as long as)
ESS_READ_LOG_DATE=${APACHE_DIR}'/READLOGDATE'
LOCK_ESS_IMPORTING=${APACHE_DIR}'/LOCKESSIMPORTING'
LOCK_ESS_SETUP=${APACHE_DIR}'/LOCKESSSETUP'
ESS_IMPORT_STATUS=${APACHE_DIR}'/STATUSIMPORT'
ESS_IMPORT_TIMESTAMP=${APACHE_DIR}'/STARTTIMEIMPORT'
ESS_CACHE_DIRNAME=${APACHE_DIR}'/CACHEDIRNAME'
ESS_USER_STATUS=${APACHE_DIR}'/USERASCOOKIE'
LOCAL_MASTER_MANAGE_DIR=${ESS_ROOT}'/.local'
LOCAL_MASTER_STATUS=${LOCAL_MASTER_MANAGE_DIR}'/userascookie'
}

deffiles


COOKIE_DELIM='---'

# --
# Hard Coded Variables
# --
#ENT_CLICK="ent==2"
#ENT_LISTING="ent==3"
ENT_CLICK='ent=="click"'
ENT_LISTING='ent=="listing"'
WEB_LOG='src=="web"'
AD_LOG='src=="ad"'
CV_LOG='src=="cv"'



