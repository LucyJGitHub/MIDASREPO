     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate TIN')                                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTINN - Validate TIN                                       *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD050570           Date 25Jun18               *
      *  Prev Amend No. CGL177             Date 11Jan16               *
      *                 MD036335           Date 28Oct15               *
      *                 MD036274  *CREATE  Date 21Oct15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050570 - Error message for High Value Account is not being *
      *             displayed correctly                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036335 - Protect evidence field if CSD093 is off           *
      *  MD036274 - Local TIN validation changes                      *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,ERR_XARRYS

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

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for Access Programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D SVAL01          C                   CONST('CRSLocalTINMandatory')

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                            MD050570
     D BChar           DS                                                                   MD050570
     D   BLen                  1      2B 0                                                  MD050570
     D   LenStr                1      2                                                     MD050570

     D Prtcd           S              7
     D POptn           S              7
     D PCRSChk         s              1
     D DDCTRY          S              2
     D DDSUBJ          S              1
     D DDCODO          S              1
     D DDJACM          S              1
     D DDMAIL          S              1
     D DDPHON          S              1
     D DDRPAY          S              1
     D DDTINN          S             25
     D DDTINNOK        S              1
     D DFTINN          S             25
     D DFTINS          S              1                                                       CGL177
     D SVALK1          S             20
     D SVAL1           S            200
     D SVALK2          S             20
     D SVAL2           S            200
     D SVALK3          S             20
     D SVAL3           S            200
     D SVALK4          S             20
     D SVAL4           S            200
     D SVALK5          S             20
     D SVAL5           S            200
     D SVALK6          S             20
     D SVAL6           S            200
     D SVALK7          S             20
     D SVAL7           S            200
     D SVALK8          S             20
     D SVAL8           S            200
     D SVALK9          S             20
     D SVAL9           S            200
     D SVALK10         S             20
     D SVAL10          S            200

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialization

     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        DFTINN
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      'Y'           DDTINNOK

      ** Country must be the local country
     C                   IF        DDCTRY = BJCNCD
     C                             AND DDTINN = *Blanks
     C                             AND SVAL1 = 'Y'

      ** Check if came from CRS validation
     C                   IF        PCRSChk = 'Y'
     C                   IF        DDSUBJ = 'Y'
     C                             OR (DDSUBJ = ' '
     C                             AND (DDCODO = 'Y'
     C                             OR DDJACM = 'Y'
     C                             OR DDMAIL = 'Y'
     C                             OR DDPHON = 'Y'
     C                             OR DDRPAY = 'Y'))
     C                   MOVE      'N'           DDTINNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTINN'      FldNamXAr(Idx)
     C                   MOVEL     'USS0657'     MsgIdXAr(Idx)                              MD036335
     C**********         MOVEL     DDCTRY        MsgDtaXAr(Idx)                    MD036335 MD050570
     C                   EVAL      BLen = %Len(%Trim(DDCTRY))                               MD050570
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDCTRY)                   MD050570

     C                   ENDIF

     C                   ELSE
     C                   MOVE      'N'           DDTINNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTINO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0656'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        Idx = 0
     C                   EVAL      DFTINN = DDTINN
     C                   IF        DFTINN <> *Blanks                                          CGL177
     C                   EVAL      DFTINS = 'Y'                                               CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF

      ** RETURN

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: SDACRV1VL                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Return Code
     C                   PARM                    ReturnCode
     C                   PARM                    PCRSChk

      ** TIN
     C                   PARM                    DDTINN
     C                   PARM                    DDCTRY
     C                   PARM                    DDSUBJ
     C                   PARM                    DDCODO
     C                   PARM                    DDJACM
     C                   PARM                    DDMAIL
     C                   PARM                    DDPHON
     C                   PARM                    DDRPAY

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** TINN
     C                   PARM                    DDTINNOK
     C                   PARM                    DFTINN
     C                   PARM                    DFTINS                                       CGL177

      ** Check CRSLocalTINMandatory
     C                   CALL      'AOSVALR0'
     C                   PARM                    Prtcd
     C                   PARM      SVAL01        SVALK1
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK10
     C                   PARM                    SVAL10

      ** If the system value is not found then issue a database error
     C                   IF        Prtcd <> '*NRF' AND
     C                             Prtcd <> *BLANKS

     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 001
     C                   EVAL      DBKey = SVALK1

     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRtcd <> *BLANK
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2015
