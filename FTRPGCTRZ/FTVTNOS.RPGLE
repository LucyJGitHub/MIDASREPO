     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Validate To Nostro')          *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVTNOS - Midas FT Nostro Transfer Validate To Nostro        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD034926           Date 09Jul15               *
      *  Prev Amend No. CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034926 - Value date should not be earlier than the Date    *
      *             Account Opened whether it is a Nostro or a Retail *
      *             Nostro Account                                    *
      *  CAP212 - FT Nostro Transfer API                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Account Master Details
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Transfer Details in screen format
     D TrnDets       E DS                  EXTNAME(FTFTNTPD)

      ** Transfer Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(FTEFTNTPD)

      ** Valid Transfer Details layout
     D ValidNoTr     E DS                  EXTNAME(FTVFTNTPD)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for DBERR on ACCNT
     D ACKeyDS         DS
     D  KCNUM                  1      6
     D  KCCY                   7      9
     D  KACOD                 10     19  0
     D  KACSQ                 20     21  0
     D  KBRCA                 22     24

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0

     D PRTCD           S              7
     D POPTN           S              7
     D PCUST           S              6
     D PCCY            S              3
     D PACOD           S             10
     D PACSQ           S              2
     D PNONB           S              2
     D PBRCA           S              3
     D PCSSN           S             10
     D PPNOI           S              1

     D WACST           S              1
     D WDACO           S              5  0
     D WATYP           S              1
     D WRETB           S              1
     D BVLD            S              5  0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization

     C                   MOVE      *BLANK        ReturnCode

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx

      *
      ** VALIDATION

      ** To Nostro is mandatory
     C                   IF        NTTNOS = *BLANKS
      *
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047442'
     C                   GOTO      EMAIN
      *
     C                   ENDIF

      ** To nostro must not equal from nostro
     C                   IF        NTTNOS = NTFNOS
      *
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047443'
     C                   GOTO      EMAIN
      *
     C                   ENDIF

      ** Do next validations only if currency is valid
     C                   IF        OKCCY <> 'Y'
     C                   GOTO      EMAIN
     C                   ENDIF

      ** Validate currency and to nostro combination
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      *BLANKS       PCUST
     C                   PARM      NVCCY         PCCY
     C                   PARM      *BLANKS       PACOD
     C                   PARM      *BLANKS       PACSQ
     C                   PARM      NTTNOS        PNONB
     C                   PARM      *BLANKS       PBRCA
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
      *
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047444'
     C                   GOTO      EMAIN
      *
     C                   ENDIF

      ** Access nostro full account
     C                   MOVE      A7CUST        KCNUM
     C                   MOVE      A7CYCD        KCCY
     C                   MOVE      A7ACCD        KACOD
     C                   MOVE      A7ACSN        KACSQ
     C                   MOVE      A7BRCD        KBRCA
     C     AccntKey      CHAIN     ACCNT

     C                   IF        NOT %FOUND OR
     C                             RECI <> 'D'
     C                   EVAL      DBFILE = 'ACCNT'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = ACKeyDS
     C                   EVAL      DBPGM = 'FTVFNOS'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      ACST          WACST
     C                   Z-ADD     DACO          WDACO
     C                   MOVE      ATYP          WATYP
     C                   BITOFF    '01234567'    WRETB
     C                   MOVE      RETB          WRETB

      ** Check Status of Account

      *** Blocked Credit
     C                   TESTB     '3'           WRETB                    98
     C                   IF        *IN98 = *ON
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047496'
     C                   GOTO      EMAIN
     C                   ENDIF

      *** Bankrupt/Liquidated
     C                   TESTB     '6'           WRETB                    98
     C                   IF        *IN98 = *ON
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047490'
     C                   GOTO      EMAIN
     C                   ENDIF

      *** Bad Debt
     C                   TESTB     '7'           WRETB                    98
     C                   IF        *IN98 = *ON
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047491'
     C                   GOTO      EMAIN
     C                   ENDIF

      *** Inactive
     C                   TESTB     '4'           WRETB                    98
     C                   IF        *IN98 = *ON
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047492'
     C                   GOTO      EMAIN
     C                   ENDIF

      *** Referred Credit
     C                   TESTB     '1'           WRETB                    98
     C                   IF        *IN98 = *ON
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047497'
     C                   GOTO      EMAIN
     C                   ENDIF

      ** Do next validations only if value date is valid
     C                   IF        OKVDAT <> 'Y'
     C                   GOTO      EMAIN
     C                   ENDIF

      ** Check if value date is in the future and the account is
      ** closing today
     C                   IF        NVVDAT > BJRDNB AND
     C                             WACST = 'C'

     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047439'
     C                   GOTO      EMAIN

     C                   ENDIF

      ** If retail account, check if value date is before the backvalue
      ** limit date or account opening date
      ** Validate also the value date against the account opening of a                      MD034926
      ** Nostro Account.                                                                    MD034926
      *                                                                                     MD034926
     C**********         IF        WATYP = 'R'                                              MD034926
     C                   IF        WATYP = 'R' or WATYP = 'N'                               MD034926
      *
     C**********         IF        NVVDAT < BVLD                                            MD034926
     C                   IF        NVVDAT < BVLD and WATYP = 'R'                            MD034926
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047440'
     C                   GOTO      EMAIN
     C                   ENDIF
      *
     C                   IF        NVVDAT < WDACO
     C                   EVAL      OKTNOS = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTTNOS    '
     C                   EVAL      MsgIdXAr(Idx) = '5047441'
     C                   GOTO      EMAIN
     C                   ENDIF
      *
     C                   ENDIF

      ** Move value to valid file
     C                   MOVE      NTTNOS        NVACBN

      * RETURN

     C     EMAIN         TAG

     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      * OK Flags
     C                   PARM                    OKTrnDets
      *
      * Validation Fields
     C                   PARM                    ValidNoTr

      *
      * Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     BJRDNB        SUB       BJBVPD        BVLD
      *
      * Key list definition
     C     AccntKey      KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
