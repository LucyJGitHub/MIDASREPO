     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Get Extract Parameters')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXGETEXTP - Get Extract Parameters                           *
      *                                                               *
      *  Function:  This module gets extract parameters for a         *
      *             composite or format                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW034             Date 09Jan04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205751             Date 14May02               *
      *                 205418             Date 02May02               *
      *                 CMX011             Date 28Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189208             Date 25Jan01               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  CSW034 - Midas Message Manager Global Processing             *
      *  205751 - Allow output to DTAQ for single file format         *
      *  205418 - Unable to pick up the dataq name for single file    *
      *           format download.                                    *
      *  CMX011 - Enable Meridian Export to use data queue as well as *
      *           MQ queue.                                           *
      *  189208 - Consolidation of Loans & participations into 1 fmt  *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXCOMDPD  IF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXCOMFPD  IF   E           K DISK    INFSR(*PSSR)
      * Composite Message Formats
 
     FMXCOMFL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MXCOMFP0: MXCOMFALT)
      * Composite Message Formats
 
     FMXEXFDL2  IF   E           K DISK    INFSR(*PSSR)
      * Export Format Details
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
     D*#_DTAG**********S              4    DIM(14) CTDATA PERRCD(1)             CMX003
     D*#_MODI**********S              3    DIM(14) CTDATA PERRCD(1)             CMX003
     D*#_DTAG**********S              4    DIM(15) CTDATA PERRCD(1)      CMX003 189208
     D*#_MODI**********S              3    DIM(15) CTDATA PERRCD(1)      CMX003 189208
     D #_DTAG          S              4    DIM(16) CTDATA PERRCD(1)             189208
     D #_MODI          S              3    DIM(16) CTDATA PERRCD(1)             189208
 
     DQueueInfo        DS                                                       CMX011
     D QueueType               1      5                                         CMX011
     D QueueName               6     48                                         CMX011
                                                                                CMX011
     DLibName          S             10                                         CMX011
     DQName            S             10                                         CMX011
     DTextLen          S              2  0
     I*                                                                         205418
      ** Rename message queue name in MXEXFDL2 to be the same as                205418
      ** MXCOMDPD composite file message queue                                  205418
      *                                                                         205418
     IMXEXFDP0                                                                  205418
     I              EXMSGQ                      CDMSGQ                          205418
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
     C                   PARM                    I#FMT            10
      * OUTPUT
     C                   PARM                    Data_Group        4
     C                   PARM                    Member           10
     C                   PARM                    DRV_Activ         3
     C                   PARM                    DRV_File         10
     C                   PARM                    ModuleID          3
     C                   PARM                    DataQueue        20            CMX011
     C                   PARM                    KeyedDTAQ         1            CSW034
 
      * Clear outputs
 
     C                   MOVE      *BLANK        Data_Group
     C                   MOVE      *BLANK        Member
     C                   MOVE      *BLANK        DRV_Activ
     C                   MOVE      *BLANK        DRV_File
     C                   MOVE      *BLANK        ModuleID
     C                   MOVE      *BLANK        DataQueue                      CMX011
     C                   MOVE      *BLANK        KeyedDTAQ                      CSW034
 
     C                   SELECT
 
      * WHEN PROCESSING A SINGLE FORMAT
      * -------------------------------
 
     C     I#COMI        WHENEQ    '*NONE   '
 
     C     I#FMT         CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING FORMAT:'
     C                             + I#FMT
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     EXXMEM        Member
     C                   MOVEL     EXFILE        DRV_File
      *                                                                         205751
      ** Check if the output is for Data queue                                  205751
     C                   MOVEL     CDMSGQ        QueueInfo                      205751
     C                   MOVE      *BLANKS       LibName                        205751
     C                   MOVE      *BLANKS       QName                          205751
     C*****              IF        QueueType = 'DTAQ/'                                        CSW034
     C     QueueType     IFEQ      'KTAQ/'                                                    CSW034
     C                   MOVE      'Y'           KeyedDTAQ                                    CSW034
     C                   ENDIF                                                                CSW034
     C     QueueType     IFEQ      'DTAQ/'                                                    CSW034
     C     QueueType     OREQ      'KTAQ/'                                                    CSW034
     C                   EVAL      TextLen = %SCAN('/':CDMSGQ:6)                205751
     C                   IF        TextLen <> 0                                 205751
     C                   EVAL      LibName = %SUBST(CDMSGQ:6:TextLen-6)         205751
     C                   ENDIF                                                  205751
     C                   EVAL      QName=%SUBST(CDMSGQ:TextLen+1:10)            205751
     C                   EVAL      DataQueue = LibName + QName                  205751
     C                   ENDIF                                                  205751
 
      * WHEN PROCESSING A COMPOSITE
      * ---------------------------
 
     C                   OTHER
 
     C     MXCOMDK       CHAIN     MXCOMDP0                           99        *
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING COMPOSITE:'
     C                             + I#COMI + I#EXTT
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     CDDTAG        Data_Group
     C                   MOVEL     CDXMEM        Member
                                                                                CMX011
      * Check if the output is for Data queue                                   CMX011
                                                                                CMX011
     C                   MOVEL     CDMSGQ        QueueInfo                      CMX011
     C                   MOVE      *BLANKS       LibName                        CMX011
     C                   MOVE      *BLANKS       QName                          CMX011
     C*****              IF        QueueType = 'DTAQ/'                                 CMX011 CSW034
     C     QueueType     IFEQ      'KTAQ/'                                                    CSW034
     C                   MOVE      'Y'           KeyedDTAQ                                    CSW034
     C                   ENDIF                                                                CSW034
     C     QueueType     IFEQ      'DTAQ/'                                                    CSW034
     C     QueueType     OREQ      'KTAQ/'                                                    CSW034
     C                   EVAL      TextLen = %SCAN('/':CDMSGQ:6)                CMX011
     C                   IF        TextLen <> 0                                 CMX011
     C                   EVAL      LibName = %SUBST(CDMSGQ:6:TextLen-6)         CMX011
     C                   ENDIF                                                  CMX011
     C                   EVAL      QName=%SUBST(CDMSGQ:TextLen+1:10)            CMX011
     C                   EVAL      DataQueue = LibName + QName                  CMX011
     C                   ENDIF                                                  CMX011
 
      * If an activity extract
 
     C     I#EXTT        IFEQ      'A'
 
      * Check whether there are daily or monthly events in the composite
 
     C     MXCOMDK       SETLL     MXCOMFP0                                     *
     C     MXCOMDK       READE     MXCOMFP0                               99    *
     C     *in99         DOWEQ     '0'
 
      * Access each format's details
 
     C     CFFMT         CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING FORMAT:'
     C                             + CFFMT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Daily Events
 
     C     EXACSM        IFEQ      'MXACSDEDL '
     C     EXACSM        OREQ      'MXACSDEGL '
     C     EXACSM        OREQ      'MXACSDELEF'
     C     EXACSM        OREQ      'MXACSDELEL'
     C     EXACSM        OREQ      'MXACSDESET'
     C     EXACSM        OREQ      'MXACSDESEB'                                 CMX003
     C                   MOVEL     'DEV'         DRV_Activ
     C                   ENDIF
 
      * Monthly Events
 
     C     EXACSM        IFEQ      'MXACSMEDL '
     C     EXACSM        OREQ      'MXACSMEGL '
     C     EXACSM        OREQ      'MXACSMELEF'
     C     EXACSM        OREQ      'MXACSMELEL'
     C     EXACSM        OREQ      'MXACSMESET'
     C     EXACSM        OREQ      'MXACSMESEB'                                 CMX003
     C                   MOVEL     'MEV'         DRV_Activ
     C                   ENDIF
 
      * Balances
 
     C     EXACSM        IFEQ      'MXACSBLDL '
     C     EXACSM        OREQ      'MXACSBLGL '
     C     EXACSM        OREQ      'MXACSBLLEL'
     C                   MOVEL     'BAL'         DRV_Activ
     C                   ENDIF
 
     C     MXCOMDK       READE     MXCOMFP0                               99    *
     C                   ENDDO
 
      * Error if no activity driver format found
 
     C     DRV_Activ     IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO EVENTS/BALANCES:'
     C                             + I#COMI + I#EXTT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get module ID
 
     C                   Z-ADD     1             #D                2 0
     C     Data_Group    LOOKUP    #_DTAG(#D)                             99
     C     *in99         IFEQ      '0'
     C                   EVAL      I#ERMS = 'INVALID DATA GROUP:'
     C                             + Data_Group
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     #_MODI(#D)    ModuleID
 
     C                   ENDIF
 
      * Get *DRIVER format for the composite ID and extract type
 
     C                   MOVEL     '*DRIVER   '  CFLFMT
     C     MXCOMFK       CHAIN     MXCOMFALT                          99        *
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'NO DRIVER:'
     C                             + I#COMI + I#EXTT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Access the 'driver' file
 
     C     CFFMT         CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING FORMAT:'
     C                             + CFFMT
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     EXFILE        DRV_File
 
     C                   ENDSL
 
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Key Lists
 
     C     MXCOMDK       KLIST
     C                   KFLD                    I#COMI
     C                   KFLD                    I#EXTT
     C     MXCOMFK       KLIST
     C                   KFLD                    I#COMI
     C                   KFLD                    I#EXTT
     C                   KFLD                    CFLFMT
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** #_DTAG
ACCT
FXDL
LDNI
NASP
NASS
FRAS
SIRS
CIRS
CFCO
CLLN
CLPS
CLGU
CLZZ                                                                            189208
FCLT
STRD
SBPS                                                                            CMX003
** #_MODI
GL
DL
DL
DL
DL
DL
DL
DL
DL
LEL
LEL
LEL
LEL                                                                             189208
LEF
SET
SEB                                                                             CMX003
