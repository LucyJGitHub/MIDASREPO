     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management Interface Controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDDCMTCTL - SD Document Management Interface Controller      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Valid Document Management
     FSDVDCMTPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas SD Invalid Document Management
     FSDIDCMTPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas SD Valid Document Management by Front Office ID
     FSDVDCMTL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDVDCMTD0:SDDCMTFOID)

      ** ZA Sequence numbbers for input fields
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes definition  for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

      /COPY ZACPYSRC,PROCPARMS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.

      /COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.

      /COPY ZACPYSRC,APICTLARR

      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.

      /COPY ZACPYSRC,DTAQCHKDCL

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Incoming Header
     D PHeadIn       E DS                  EXTNAME(APHEADPD)

      ** Incoming Details
     D NwDcScnFmt    E DS                  EXTNAME(SDDCMSPD)

      ** Valid Details
     D NwDcFilFmt    E DS                  EXTNAME(SDVDCMTPD)

      ** Current Details in Screen Format
     D CrDcScnFmt    E DS                  EXTNAME(SDDCMSPD)
     D                                     PREFIX(Cr)

      ** Current Deal in File Format
     D CrDcFilFmt    E DS                  EXTNAME(SDDCMTPD)

      ** Error Indicator File
     D OkFlags       E DS                  EXTNAME(SDEDCMTPD)

      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Time Format
     D WWCTIM          DS
     D  WWHH                   1      2
     D  WWC1                   3      3    INZ(':')
     D  WWMM                   4      5
     D  WWC2                   6      6    INZ(':')
     D  WWSS                   7      8

      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0

     D PRTCD           S              7A
     D POPTN           S              7A

      ** Mode of Operation
     D PModeofop       S              6A

      ** Index for arrays of error message ids etc
     D PIdx            S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Field (500A) to receive the incoming transaction
     D PTrans500       S            500A

      ** Field (500A) to receive the incoming Extra Data
     D PExtData500     S            500A

      ** Indicies for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Substitution Character
     D PSubsChar       S              1A

      ** Incoming Data
     D PIncDATA        S           2000A

      ** Current Data
     D PCurDATA        S           2000A

      ** Overall Transaction status, to be passed to the Message Handler
     D PTranStatus     S              1A

      ** Whether or not to clear the program message queue
     D PClrPgmMsgQ     S              1A

      ** Module ID, to be passed to the Message Handler
     D PModuleID       S              2A

      ** Work Variables
     D WMQError        S             28A
     D PMQErrLong      S            132A
     D PMQReturn       S             10A

      ** Parameters for APCALCOBJ
     D PObject         S             10A   INZ('SDDCMTUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcobj         S              1A   INZ('Y')
     D PReturn         S              7A

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A

      ** Timestamp for the transaction
     D PTimeStamp      S               Z

      ** Midas Transaction ID
     D PTranID         S             20A

     D TransDtl        S           5800A
     D PCustNum        S             18A
     D PACustNo        S             18A
     D PINSEQ          S              3S 0
     D PINTYP          S              1A
     D PINMOD          S              1A
     D PIREFN          S             10A
     D RespMode        S              1A   INZ('S')

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.

     C                   EVAL      NwDcScnFmt = PTrans500

      ** Generate a timestamp for this transaction

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp

      ** Reset variables gradually updated

     C                   EXSR      SRReset

      ** Check if valid record exists for Front Office ID

     C                   EXSR      SRValRec

      ** If valid record does exist (even after delay), fail this input

     C                   IF        PIdx <> 0
     C                   GOTO      INVALID
     C                   END

      ** Transaction Details Data Substitution

     C                   IF        GHSUBS <> *Blanks
     C     GHSUBS        SCAN      NwDcScnFmt                             01
     C                   IF        *IN01 = *On
     C                   EXSR      SRSubsDtas
     C                   ENDIF
     C                   ENDIF

      ** Validate Main Details

     C                   EXSR      SRValDet

     C     INVALID       TAG

      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program

     C                   IN        APDUMP

     C                   IF        ARERRMOD <> *BLANK
     C                   EVAL      PMQErrLong = *Blanks
     C                   EVAL      WMQError = ProcErr
     C                   EVAL      WMQError = ARERRMOD
     C                   EVAL      PMQErrLong = WMQError

     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMQReturn
     C                   PARM                    PMQErrLong
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF

     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN

     C                   ELSE

      ** Processing for Error checking/write to database

     C                   EXSR      SRChkWrite

      ** If valid, send data queue entry to prompt DB update program

     C                   IF        PIdx = 0
     C                   EVAL      PObjType = '*DTAARA'

      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running

     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockState
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM      *BLANK        PReturn

     C                   IF        PReturn = *Blanks

      ** Check if any messages are already on the data queue
      ** No need to send duplicate prompt messages

      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.

      /COPY ZACPYSRC,DTAQCHK

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValRec - Check if valid record exists for Front Office ID   *
      *                                                               *
      *****************************************************************

     C     SRValRec      BEGSR

     C                   MOVE      DDSEQN        PINSEQ

     C                   CALLB     'SDDCMTRTV'
      *
      ** INPUTS
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '*FRONT '     PMODE             6
      *
      ** Response mode
     C                   PARM      'S'           RespMode
      *
      ** Entry Mode
     C                   PARM                    PINMOD
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Customer and Document Code
     C                   PARM      DDREFN        PIREFN
     C                   PARM      DDRTYP        PINTYP
     C                   PARM                    DDCODE
     C                   PARM                    PINSEQ
      *
      ** Front Office Transaction ID
     C                   PARM      DDFOTRANID    FOTRID           20
      *
      ** OUTPUTS
      *
      ** (Current) deal in file format
     C                   PARM                    CrDcFilFmt
      *
      ** OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      ** OK - Security
     C                   PARM      *BLANK        DDREFNOK
      *
     C                   PARM      *BLANK        DDCODEOK
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         PIdx
      *
      ** Document Code narrative
     C                   PARM                    DDNARR

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDet - Validate Main Details                              *
      *                                                               *
      *****************************************************************

     C     SRValDet      BEGSR

     C                   MOVE      *All'Y'       OkFlags

     C                   CALLB     'SDDCMTVAL'

      ** Return Code
     C                   PARM      *BLANK        APRESPMODE

      ** New Details in Screen Format
     C                   PARM                    NwDcScnFmt

      ** Output Parameters
      ** =================

      ** Screen error indicators
     C                   PARM                    OkFlags

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    PIdx

      ** New Details in File Format
     C                   PARM                    NwDcFilFmt

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubsDtas - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************

     C     SRSubsDtas    BEGSR

      ** Data Substitution

     C                   RESET                   ReturnCode
     C                   CLEAR                   PIncDATA
     C                   CLEAR                   PCurDATA
     C                   CALLB     'APDTASUBS'

      ** Return Code
      ** Substitution character
      ** Incoming Data
      ** Current Data

     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        PSubsChar
     C                   PARM      NwDcScnFmt    PIncDATA
     C                   PARM      CrDcScnFmt    PCurDATA

     C                   EVAL      NwDcScnFmt = PIncDATA

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkWrite  - Controls the checking of error status and       *
      *               sending of messages/writing to the database     *
      *                                                               *
      *****************************************************************

     C     SRChkWrite    BEGSR

     C                   IF        PIdx = 0

      ** Write to Valid file

     C                   EXSR      SRSetValid

     C                   WRITE     SDVDCMTD0
     C                   EXSR      SRCallMsgH

     C                   ENDIF

      ** If Record is invalid

     C                   IF        PIdx > 0
     C                   EXSR      SRSetInval

      ** Only write to invalid files if repair in back office

     C                   IF        APRPRLOCN = 'B'
     C                   WRITE     SDIDCMTD0
     C                   ENDIF

     C                   EXSR      SRCallMsgH
     C                   ENDIF

     C                   COMMIT

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReset   - Reset error information that is gradually         *
      *             updated during each run of this program           *
      *                                                               *
      *****************************************************************

     C     SRReset       BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   PIdx

     C                   RESET                   FldNoArr

     C                   RESET                   OKFlags

     C                   CLEAR                   NwDcFilFmt

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetInval - Set up Invalid Record                            *
      *                                                               *
      *****************************************************************

     C     SRSetInval    BEGSR

     C                   EVAL      DDFOTRANID = APFOTRANID
     C                   EVAL      DDRPRLOCN = APRPRLOCN
     C                   MOVE      PTimeStamp    DDTMESTMP

     C                   EVAL      PTranStatus = 'F'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetValid - Set up Valid Record                              *
      *                                                               *
      *****************************************************************

     C     SRSetValid    BEGSR

     C                   EVAL      DVREFN = DDREFN
     C                   EVAL      DVRTYP = DDRTYP
     C                   EVAL      DVCODE = DDCODE

     C                   MOVE      DDSEQN        DVSEQN

     C                   EVAL      DVDREF = DDDREF

     C                   EVAL      DVSTCD = DDSTCD
     C                   EVAL      DVISCT = DDISCT

     C                   EVAL      DVISDT = *ZERO
     C                   IF        DDISDT <> *BLANKS
     C                   MOVE      DDISDT        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT

     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        DVISDT
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DVEXDT = *ZERO
     C                   IF        DDEXDT <> *BLANKS
     C                   MOVE      DDEXDT        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT

     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        DVEXDT
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DVRQDT = *ZERO
     C                   IF        DDRQDT <> *BLANKS
     C                   MOVE      DDRQDT        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT

     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        DVRQDT
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DVRCDT = *ZERO
     C                   IF        DDRCDT <> *BLANKS
     C                   MOVE      DDRCDT        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT

     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        DVRCDT
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DVREJC = *ZERO
     C                   IF        DDREJC <> *BLANKS
     C                   MOVE      DDREJC        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT

     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        DVREJC
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DVREQB = *ZERO
     C                   IF        DDREQB <> *BLANKS
     C                   MOVE      DDREQB        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT

     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        DVREQB
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DVCUSR = DDCUSR

     C                   EVAL      DVCDAT = *ZERO
     C                   IF        DDCDAT <> *BLANKS
     C                   MOVE      DDCDAT        WUWSDT
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT

     C                   IF        *IN90 = *ON
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DBKEY = PCustNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      WUWFDT        DVCDAT
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      WWCTIM = DDCTIM
     C                   EVAL      DVCTIM = WWHH + WWMM + WWSS
     C                   EVAL      DVCOMM = DDCOM1 + DDCOM2 +
     C                                      DDCOM3 + DDCOM4
     C                   EVAL      DVIMGE = DDIMGE

     C                   EVAL      DVLCDT = BJRDNB
     C                   EVAL      DVLTYP = DDACTN
     C                   MOVEL     PTimeStamp    DVTMST
     C                   EVAL      DVLUSR = PSUSER
     C                   EVAL      DVREPA = APRPRLOCN
     C                   EVAL      DVFOID = APFOTRANID

     C                   EVAL      PTranStatus = 'S'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallMsgH - Call the Message Handling module                 *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     SRCallMsgH    BEGSR

      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors

     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax

     C                   IF        FldNameArr(Ix) <> *Blanks

     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)

     C                   ELSE

     C                   LEAVE

     C                   ENDIF

     C                   ADD       1             Ix
     C                   ENDDO

     C                   RESET                   ReturnCode

     C                   EVAL      PTranID = DDREFN

     C                   CALLB     'ZAMSGHNDLE'

      ** Return code (10A, returned to this procedure)
      ** Repair location (1A, from caller)
      ** Confirm validity to front office (1A, from caller)

     C                   PARM                    ReturnCode
     C                   PARM                    APRPRLOCN
     C                   PARM                    APCNFVALFO

      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )

     C                   PARM                    MsgIDArr

      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)

     C                   PARM                    FldNoArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgDtaArr

      ** Front office transaction identifier (20A, from caller)
      ** Midas module ID (2A)
      ** Midas transaction ID (20A, from caller)
      ** Message file (10A, from caller)

     C                   PARM                    APFOTRANID
     C                   PARM                    PModuleID
     C                   PARM                    PTranID
     C                   PARM                    #MsgFile

      ** Action code of transaction (1A, from transaction)
      ** Status of transaction (1A, F=Failure, S=Success)
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))

     C                   PARM                    DDACTN
     C                   PARM                    PTranStatus
     C                   PARM                    APRESPMODE

      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
      ** Screen-handling module (10A, from caller)
      ** Screen-handling procedure (10A, from caller)

     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      ** The MQSeries queue to send replies to
      ** The transaction's timestamp
      ** Additional Message files to check
      ** Whether or not to clear the program message queue.

     C                   PARM                    APRPYQUEUE
     C                   PARM                    PTimeStamp
     C                   PARM                    MsgFArray
     C                   PARM                    PClrPgmMsgQ

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Common header information (DS) from source system

     C                   PARM                    PHeadIn

      ** Transaction information in a single large field from source system

     C                   PARM                    PTrans500
     C                   PARM                    PExtData500

      ** Ultimate calling Program/Module/Procedure

     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      ** Set up the name of the MSGF from which the message handler will
      **  get the messages

     C                   EVAL      #MsgFile = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'

      ** Set up the Module ID, used to make the Transaction number unique

     C                   EVAL      PModuleID = 'SD'

      ** Set up the name of the server/database updater data queue.

     C                   EVAL      DtaQName = 'APDCMTDTQ'

      ** Access Bank details via access program

     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDAPIPD '
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

     C/COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2013
