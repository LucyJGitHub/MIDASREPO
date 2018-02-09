     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate Up-Front Fee Amount')                *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing ILE Module                           *
      *                                                               *
      *  IRVUPFE01 - Validate Up-Front Fee Amount                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 245692             Date 10Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP041  *CREATE    Date 07Jan02               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
 
 
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
      *
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
      *
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D WUPFE           S             13P 0
     D WUCDP           S              1P 0
     D WTCDP           S              1P 0
 
     D  ZField         S             16A
     D  ZFld15         S             15P 0
     D  ZADig          S              2P 0
     D  ZADec          S              1P 0
     D  ZDecs          S              1P 0
     D  ZECode         S              1A
     D  ZOut21         S             21A
     D  ZAlignOk       S              1A
 
                                                                                              245692
      ** Decimal separator                                                                    245692
     D BNDCSP          S              1A                                                      245692
                                                                                              245692
      ** Parameter list for ZA0840                                                            245692
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ** Error return code for ZA0840 module                                                  245692
     D @@ERCD          S              1  0                                                    245692
     D/COPY QWINDSRC,IRCIRSGDTA
 
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
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
      *
      ** Validate Up-Front Fee amount
      *
     C                   EXSR      SRValUPFE
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKUFEE = 'N'
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C                   Z-ADD     WUPFE         #1UPFE
 
     C                   ENDIF
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRValUPFE - Validation for Up-Front Fee Amount               *
      *                                                               *
      *****************************************************************
     C     SRValUPFE     BEGSR
      *
     C                   Z-ADD     0             WUPFE
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
      *
      ** Validate Up-front Fee Amount depening if it has
      ** been entered or not.
      *
     C                   SELECT
 
     C     SUFEE         WHENEQ    *BLANKS
      *
      ** If Up-Front fee value date and pay/rec indicator
      ** are not blank, the amount cannot be blank.
      *
     C                   IF        SUFVD <> *BLANKS or SUFPR <> *BLANKS
 
     C                   EVAL      OKUFEE = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SUFEE     '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00047'
 
     C                   GOTO      ESRValUPFE
 
     C                   ENDIF
 
     C                   OTHER
      *
      ** Up-Front Fee must be a valid numeric field
      ** with the correct number of decimal places
      ** depending on currency (based on the pay/rec
      ** indicator).
      *
     C                   IF        OKUFPR <> 'N' and SUFPR <> *BLANKS
 
     C**********         MOVE      *BLANKS       ZField                                       245692
     C**********         MOVE      SUFEE         ZField                                       245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      SUFEE         @@ALPH                                       245692
 
     C                   IF        SUFPR = 'P'
     C                   Z-ADD     WUCDP         ZADec
     C                   Z-ADD     WUCDP         @@IDP                                        245692
     C                   ELSE
     C                   Z-ADD     WTCDP         ZADec
     C                   Z-ADD     WTCDP         @@IDP                                        245692
     C                   ENDIF
 
     C*****13***         SUB       ZADEC         ZADig                                        245692
     C     13            SUB       ZADEC         @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
 
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM                    ZALignOk                                     245692
     C**********         PARM                    ZField                                       245692
     C**********         PARM                    ZADec                                        245692
     C**********         PARM                    ZADig                                        245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
 
     C**********         IF        ZALignOk = 'N'                                             245692
     C     @@ERCD        IFNE      0                                                          245692
 
     C                   EVAL      OKUFEE = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SUFEE     '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00048'
 
     C                   GOTO      ESRValUPFE
 
     C                   ELSE
 
     C**********         MOVE      ZField        WUPFE                                        245692
     C                   MOVE      @@AMT         WUPFE                                        245692
     C                   Z-ADD     WUPFE         ZFld15
     C                   Z-ADD     ZADec         ZDecs
     C                   MOVE      *BLANK        ZECode
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFld15
     C                   PARM                    ZDecs
     C                   PARM                    ZECode
     C                   PARM                    ZOut21
 
     C                   MOVE      ZOut21        SUFEE
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C     ESRValUPFE    ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** OTHERS
      ** ======
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    WUCDP
     C                   PARM                    WTCDP
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from calling programs
     C                   PARM                    Data
     C                   PARM                    BNDCSP                                       245692
 
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
**  CPY@
(c) Finastra International Limited 2002
