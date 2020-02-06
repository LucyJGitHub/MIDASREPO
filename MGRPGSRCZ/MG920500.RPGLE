     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MG Message deletion processing')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *   MG920500 - Midas MG Message Deletion Processing             *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD029017           Date 25Nov14               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD029017 - Tag 22A value is AMND instead of NEWT             *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
     FMGOREFL0  UF   E           K DISK
     F                                     RENAME(MGOREFD0:MGREFL0)
     F                                     COMMIT
 
      ** MG Transaction history file
 
     FMGHISTL7  UF   E           K DISK
     F                                     COMMIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Data structure for related reference
 
     D DSHREF          DS                  OCCURS(16)
     D  HSMODI                 1      2
     D  HSTRAN                 3      8
     D  HSTRID                 9     14
     D  HSSEQ                 15     17
 
      ** Data structure for bank file
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short data structure for access programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** Local data area
 
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
 
      ** Workstation ID
 
     D                SDS
     D  WSID                 244    253
     D  USRID                254    263
 
      ** Declared Variables
 
     D  DVTNUM         S             16
     D  DVMODI         S              2
     D  DVERCD         S              1
     D  DVMTPY         S              3
     D  DVOPTN         S              7
     D  DVRTCD         S              7
     D  CR             S              1
     D  CRLF           S              2
     D  MMEG           S              1
     D  DVSSEQ         S              2                                                     MD029017
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main - A message is deleted when the message status field on  *
      *        the reference field (MGST, PF/MGOREFPD), is equal to   *
      *        'DLTD'                                                 *
      *****************************************************************
 
      ** Receive the Transaction Reference Number and the module id
      ** of the message being deleted
 
     C     *ENTRY        PLIST
     C                   PARM                    DVTNUM           16
     C                   PARM                    DVMODI            2
     C                   PARM                    DVERCD            1
 
      ** Transaction history key
 
     C     HSKEY         KLIST
     C
     C                   KFLD                    HSMODI
     C                   KFLD                    HSTRAN
     C                   KFLD                    HSTRID
     C                   KFLD                    HSMTPY
     C                   KFLD                    HSSEQ
 
      ** Initial processing
 
     C                   EXSR      INIT
 
      ** Use the parameter TRN to access the message we are deleting
 
     C     DVTNUM        CHAIN     MGREFL0                            05
 
      ** Error message not found
 
     C                   IF        *IN05 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   EVAL      DBKEY = DVTNUM
     C                   EVAL      DBFILE = 'MGOREFL0'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Process message if not already deleted or part deleted
 
     C                   IF        MGST <> 'DLTD'
     C                             AND PTST <> 'D'
 
      ** Determine what type of message being deleted
      ** Flag single message as DeLeTeD
 
     C                   EXSR      TYPE
 
      ** COMIT all file changes
 
     C                   COMMIT
 
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  TYPE - Determine the type of message being deleted           *
      *****************************************************************
     C     TYPE          BEGSR
 
      ** Initialise multiple message flag
 
     C                   EVALR     MMEG = 'N'
     C                   EVALR     DVMTPY = MTPY
 
      ** This is a single message, hence flag as deleted
 
     C                   EVALR     MGST = 'DLTD'
     C                   EVALR     MGSG = '4'
 
      ** Update the message being deleted
 
     C                   EVAL      LADT= BJMRDT
     C                   TIME                    LATM
 
     C                   EVALR     RELD = LADT
     C                   MOVE      LATM          RELT
     C                   EVALR     RUSR = USRID
     C                   EVALR     RWSN = WSID
 
     C                   UPDATE    MGREFL0
 
      ** Delete transaction history
 
     C                   EVAL      DSHREF = DVTNUM
     C                   EVAL      HSSEQ = '000'                                            MD029017
     C                   MOVE      DVTNUM        DVSSEQ                                     MD029017
     C                   MOVE      DVSSEQ        HSSEQ                                      MD029017
     C                   EVALR     HSMTPY = MTPY
 
     C     HSKEY         CHAIN     MGHISTL7                           56
 
     C     *IN56         IFEQ      '0'
     C                   DELETE    MGHISTD0
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   INIT - inital process                                       *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Set up LDA for database error processing
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVALR     DBFILE = *BLANKS
     C                   EVALR     DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'MG920500'
     C                   Z-ADD     *ZERO         DBASE
     C                   OUT       LDA
 
      **  Access SDBANKPD for Midas rundate
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     DVRTCD
     C                   PARM      '*FIRST '     DVOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        DVRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     17            DBASE
     C                   EVAL      DBKEY = 'FIRST'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *   *PSSR - error handling                                      *
      *****************************************************************
     C     *PSSR         BEGSR
     C                   EVAL      DVERCD = 'Y'
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
