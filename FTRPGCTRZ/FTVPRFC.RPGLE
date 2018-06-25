     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Validate Profit Centre')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVPRFC - Midas FT Nostro Transfer Validate Profit Centre    *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD050862           Date 26Jun18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050862 - Profit Center Defaulting should also happen       *
      *             during amendment                                  *
      *  MD046248 - Finastra Rebranding                               *
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
      ** Nostro Transfers Details File
     FNTRAN     IF   E           K DISK
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

      ** External DS for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for GL ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)

      ** External DS for Profit Centres
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)

      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** User / Branch data area
     D ZMUSER          DS            17
     D  USRID                  1     10
     D  DPPT                  14     16

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

     D PBOKC           S              2
     D PTRTP           S              5
     D PPYST           S              2
     D PDPPT           S              3
     D PUSER           S             10
     D PACOF           S              2
     D PPRFC           S              4

     D TRTP            S              5
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

      ** If profit centre is non-blank, but Profit Centres Used is 'N',
      ** send error
     C                   IF        BKPRCU <> 'Y' AND
     C                             NTPRFC <> *BLANKS
     C                   EVAL      OKPRFC = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTPRFC    '
     C                   EVAL      MsgIdXAr(Idx) = '5047465'
     C                   GOTO      EMAIN
     C                   ENDIF

      ** If profit centre is changed, but Profit Centres Amendable is
      ** 'N', send error
     C                   IF        BKPRCA <> 'Y' AND
     C                             NTACTN = 'A'
      *
     C     NTTFRF        CHAIN     NTRAN
     C                   IF        %FOUND AND
     C                             NTPRFC <> PRFC
     C                   EVAL      OKPRFC = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTPRFC    '
     C                   EVAL      MsgIdXAr(Idx) = '5047466'
     C                   GOTO      EMAIN
     C                   ENDIF
      *
     C                   ENDIF

      ** If profit centre is blank, and to nostro & currency combination
      ** is either retail or nostro, use account's profit centre
     C                   IF        NTPRFC = *BLANKS
      *
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
     C                   MOVE      A7CUST        KCNUM
     C                   MOVE      A7CYCD        KCCY
     C                   MOVE      A7ACCD        KACOD
     C                   MOVE      A7ACSN        KACSQ
     C                   MOVE      A7BRCD        KBRCA
      *
     C     AccntKey      CHAIN     ACCNT
      *
     C                   IF        %FOUND AND
     C                             (ATYP = 'R' OR ATYP = 'N')
     C                   EVAL      NTPRFC = PRFC
     C                   ENDIF
      *
     C                   ENDIF

      ** If profit centre is blank and Profit Centre Defaults Used is
      ***'Y', use default. This is only applicable in insert mode***************************MD050862
     C** 'Y', use default. This is applicable in insert and amend                           MD050862
     C**********         IF        NTACTN = 'I' AND
     C                   IF        (NTACTN = 'I' AND
     C                             NTPRFC = *BLANKS AND
     C                             BKPCDU = 'Y' AND
     C                             OKBOKC = 'Y' AND
     C                             OKOBRC = 'Y' AND
     C**********                   OKTFST = 'Y'                                             MD050862
     C                             OKTFST = 'Y') OR                                         MD050862
     C                             (NTACTN = 'A' AND                                        MD050862
     C                             NTPRFC = *BLANKS AND                                     MD050862
     C                             BKPCDU = 'Y' AND                                         MD050862
     C                             OKBOKC = 'Y' AND                                         MD050862
     C                             OKOBRC = 'Y' AND                                         MD050862
     C                             OKTFST = 'Y')                                            MD050862
     C
      *
     C                   MOVEL     'NT'          TRTP
      *
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      NVBOKC        PBOKC
     C                   PARM      TRTP          PTRTP
     C                   PARM      NVPYST        PPYST
     C                   PARM      NVBRCA        PBRCA
     C                   PARM      DPPT          PDPPT
     C                   PARM      USRID         PUSER
     C                   PARM      *BLANKS       PACOF
     C                   PARM      *BLANKS       PCUST
     C     NTPRFC        PARM      *BLANKS       PPRFC
      *
     C                   IF        PRTCD = '2'
     C                   EVAL      OKPRFC = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTPRFC    '
     C                   EVAL      MsgIdXAr(Idx) = '5047445'
     C                   GOTO      EMAIN
     C                   ENDIF
      *
     C                   ENDIF

      ** Validate profit centre
     C                   IF        (NTPRFC <> *BLANKS OR
     C                              BGN0ST = 'Y') AND
     C                             (NTACTN = 'I' OR
     C                              NTACTN = 'A')
      *
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      NTPRFC        PPRFC
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      OKPRFC = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTPRFC    '
     C                   EVAL      MsgIdXAr(Idx) = '5047446'
     C                   GOTO      EMAIN
     C                   ENDIF
      *
     C                   ENDIF

      ** Move value to valid file
     C                   EVAL      NVPRFC = NTPRFC

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
      * Access Midas Modules
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * Access GL ICD Details
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      * Key list definition
     C     AccntKey      KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
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
