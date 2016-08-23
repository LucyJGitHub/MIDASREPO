     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review Detail Update')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDACRVUPD - Account Review details Update                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD026820           Date 06Aug14               *
      *  Prev Amend No. MD026688           Date 18Jun14               *
      *                 MD026854           Date 29May14               *
      *                 CGL132             Date 01May13               *
      *                 MD026293A          Date 12Apr14               *
      *                 MD026293           Date 10Apr14               *
      *                 MD026264           Date 08Apr14               *
      *                 MD026205           Date 07Apr14               *
      *                 CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026820 - Username recorded is different from the actual    *
      *             username used                                     *
      *           - Apply fix MD028109                                *
      *  MD026688 - Account review do not drop of the system after    *
      *             retention period                                  *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  MD026293A - Unexpected Error Messages Occurred on the        *
      *              Generated Account Review when a Complete Account *
      *              Review was Inserted Manually                     *
      *  MD026293 - Unexpected Error Messages Occurred on the         *
      *             Generated Account Review when a Complete Account  *
      *             Review was Inserted Manually (Recompile)          *
      *  MD026264 - Serious midas error when complete flag = 'Y'      *
      *  MD026205 - Serious midas error in account review             *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Account review details file
     FSDACRVL0  UF A E           K DISK    COMMIT
 
      ** Account review comment history file
     FSDARCHPD  O    E             DISK
 
      ** Account review extension file                                                      MD026293
     F***T_SDACRVEXO    E             DISK    INFSR(*PSSR)                        MD026293 MD026293A
     F**********                           RENAME(T_SDACRVEX : SDACRVEX)          MD026293 MD026293A
     FSDACEXL0  O    E             DISK    INFSR(*PSSR)                                    MD026293A
     F                                     PREFIX(EX)                                       MD026293
                                                                                            MD026293
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
 
      /COPY ZACPYSRC,PSDS
 
      /COPY ZACPYSRC,ERR_ARRAYS
 
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** New Account Review detail in File Format
     D NwARFilFmt    E DS                  Extname(SDVACRVPD)
 
      ** Account Review details
     D SDACRVDF      E DS                  EXTNAME(SDACRVPD)
 
      ** Account Review details
     D SDACRVDFTM    E DS                  EXTNAME(SDACRVPD)
     D                                     PREFIX(CH)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details for Timestamp checking
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
     D WFTMST          DS
     D  WWHH                   1      2
     D  WWMM                   3      4
     D  WWSS                   5      6
 
     D WDTMST          DS
     D  WWYr                   1      4
     D  WWMn                   5      6
     D  WWDy                   7      8
 
     D ZMUSER          DS            17                                                     MD028109
     D  WUSRID                 1     10                                                     MD028109
                                                                                            MD028109
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PTimeStamp      S             26Z
     D PRetCode        S              7A
     D KCUST           S              6A
     D KSCDT           S              5P 0
     D KSEQN           S              3S 0
     D WCUST           S              6A
     D WSCDT           S              6A
     D WSEQN           S              3A
     D WWTMST          S             26Z
     D DDCUST          S              6A
     D DDSEQN          S              3S 0
     D WWSEQN          S              3S 0                                                  MD026264
     D WARCH           S              1A
     D WCOMM           S            256A
     D WCUSC           S             10A
     D WCDAC           S              5P 0
     D WCTIC           S              8A
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D PCUST           S              6A
     D PBefCUST        S           5000A
     D PAftCUST        S           5000A
     D PBefACUS        S           5000A
     D PAftACUS        S           5000A
     D PBefFTCS        S           5000A                                                      CGL132
     D PAftFTCS        S           5000A                                                      CGL132
     D PBefJACC        S           5000A
     D PAftJACC        S           5000A
     D PBefCUAH        S           5000A
     D PAftCUAH        S           5000A
     D PBefCUXC        S           5000A                                                    MD026854
     D PAftCUXC        S           5000A                                                    MD026854
     D PACRV           S              1A
     D PELEC           S              1A                                                      CGL132
     D WDCOMP          S              1A
     D PDateIn         S              8S 0
     D PMDNO           S              5P 0
     D WReturn         S              6A
     D WType           S              1A
     D ModeofOp        S              6A
     D RespMode        S              1A
     D DDACTN          S              1A
     D DDSCDT          S              5P 0
     D FOTRID          S             20A
     D OKACTN          S              1A
     D OKCUST          S              1A
     D SDSCDTok        S              1                                                     MD026205
     D Idx             S              3P 0
     D C               S              2P 0
     D DBError         S             28
     D MsgSndRtn       S             10
     D WRTCD           S              7A
     D WOPTN           S              7A
     D WKUSER          S             10A                                                    MD028109
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
 
     C                   EXSR      SRChkOthUpd
 
     C                   IF        RetCodeIn <> *Blanks
     C                   GOTO      EXIT
     C                   ENDIF
                                                                                            MD028109
      ** Retrieve ZMUSER details.                                                           MD028109
                                                                                            MD028109
     C     *DTAARA       DEFINE                  ZMUSER                                     MD028109
     C                   IN        ZMUSER                                                   MD028109
                                                                                            MD028109
     C                   IF        PSUSER = 'QUSER'                                         MD028109
     C                   EVAL      WKUSER = WUSRID                                          MD028109
     C                   ELSE                                                               MD028109
     C                   EVAL      WKUSER = PSUSER                                          MD028109
     C                   ENDIF                                                              MD028109
 
      ** Insert or amend of account review
 
     C                   SELECT
 
     C                   WHEN      AVLTYP = 'I'
     C                   EXSR      SrIACRV
 
     C                   WHEN      AVLTYP = 'A'
     C                   EXSR      SrAACRV
 
     C                   ENDSL
 
      ** Exit From Program
     C     EXIT          TAG
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCHKOTHUPD - Check for update by another workstation         *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrCHKOTHUPD   BEGSR
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    WReturn
     C                   PARM                    WType
 
      ** Set retrieve mode to blank (Access using Midas transaction ID)
 
     C     WType         IFEQ      '0'
     C                   MOVE      '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVE      *BLANKS       ModeofOp
     C                   ENDIF
 
     C                   CALLB     'SDACRVRTV'
     C                   PARM                    RetCodeIn
     C                   PARM                    ModeofOp
     C                   PARM      ' '           RespMode
     C                   PARM      AVLTYP        DDACTN
     C                   PARM      AVCUST        DDCUST
     C                   PARM      AVSCDT        DDSCDT
     C                   PARM      AVSEQN        DDSEQN
     C                   PARM      AVFOID        FOTRID
     C                   PARM                    WDCOMP
     C                   PARM                    SDACRVDFTM
     C                   PARM                    OKACTN
     C                   PARM                    OKCUST
     C                   PARM                    SDSCDTok                                   MD026205
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Error if Timestamp is not the same (record has been changed
      ** by another workstation)
 
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original record was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
 
      ** Interactive mode:
 
     C                   IF        WTYPE = '1'
 
     C                   IF        CHARTMST <> AVTMST
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   ENDIF
 
      ** Batch mode:
     C                   ELSE
     C                   IF        OKACTN = 'N'
     C                             OR OKCUST = 'N'
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   Z-ADD     1             C
 
     C                   DOW       C <= ArrayMax
     C                             AND FldNameArr(C) <> *BLANKS
     C                   MOVEL     *BLANKS       DBError
     C                   MOVEL     MsgIDArr(C)   DBError
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrIACRV - Insert Account review details                      *
      *                                                               *
      *  Called by: Main Procedure                                    *
      *                                                               *
      *  Calls: SrZDAT10                                              *
      *                                                               *
      *****************************************************************
 
     C     SrIACRV       BEGSR
 
      ** Check first if the record exists.
 
     C                   EVAL      KCUST = AVCUST
     C                   EVAL      KSCDT = AVSCDT
     C                   EVAL      KSEQN = 999
 
     C     KACRV         SETGT     SDACRVL0
     C                   READP     SDACRVL0
 
     C                   IF        ARCUST = KCUST AND
     C                             ARSCDT = KSCDT
     C                   EVAL      AVSEQN = ARSEQN + 1
     C                   ELSE
     C                   EVAL      AVSEQN = 1
     C                   ENDIF
 
     C                   CLEAR                   SDACRVDF
 
     C                   EVAL      ARCUST = AVCUST
     C                   EVAL      ARSEQN = AVSEQN
     C                   EVAL      ARPURP = AVPURP
     C                   EVAL      ARACDT = AVACDT
     C                   EVAL      ARACTM = AVACTM
     C                   EVAL      ARSCDT = AVSCDT
     C                   EVAL      ARCOMM = AVCOMM
     C                   EVAL      ARACRF = AVACRF
     C                   EVAL      ARNSDT = AVNSDT
     C                   EVAL      ARCOMP = AVCOMP
 
      ** Get timestamp.
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WWTMST
 
     C                   MOVE      *BLANKS       ARTMST
     C                   MOVE      WWTMST        ARTMST
     C                   EVAL      WWYr = %SUBST(ARTMST:01:4)
     C                   EVAL      WWMn = %SUBST(ARTMST:06:2)
     C                   EVAL      WWDy = %SUBST(ARTMST:09:2)
     C                   MOVEL     WDTMST        PDateIN
     C                   EXSR      SrZDAT10
 
     C                   EVAL      WWHH = %SUBST(ARTMST:12:2)
     C                   EVAL      WWMM = %SUBST(ARTMST:15:2)
     C                   EVAL      WWSS = %SUBST(ARTMST:18:2)
 
     C                   IF        ARCOMP = 'Y'
     C**********         EVAL      ARCUSR = PSUSER                                          MD028109
     C                   EVAL      ARCUSR = WKUSER                                          MD028109
     C**********         EVAL      ARCDAT = PMDNO                                           MD026688
     C                   EVAL      ARCDAT = BJRDNB                                          MD026688
     C                   EVAL      ARCTIM = WFTMST
     C                   ELSE
     C                   EVAL      ARCUSR = *BLANKS
     C                   EVAL      ARCDAT = *ZERO
     C                   EVAL      ARCTIM = *BLANKS
     C                   ENDIF
 
     C                   IF        ARCOMM <> *BLANKS
     C**********         EVAL      ARCUSC = PSUSER                                          MD028109
     C                   EVAL      ARCUSC = WKUSER                                          MD028109
     C                   EVAL      ARCDAC = PMDNO
     C                   EVAL      ARCTIC = WFTMST
     C                   ENDIF
 
     C                   EVAL      ARMAGE = 'M'
     C                   EVAL      ARLTYP = 'I'
     C**********         EVAL      ARLUSR = PSUSER                                          MD028109
     C                   EVAL      ARLUSR = WKUSER                                          MD028109
     C                   EVAL      ARREPA = AVREPA
     C                   EVAL      ARFOID = AVFOID
     C                   EVAL      ARINDT = BJRDNB
 
     C                   WRITE     SDACRVD0
 
     C                   IF        ARCOMP = 'Y'
 
     C**********         CALL      'SDC009696'                                              MD026264
     C                   CALL      'SD009696'
     C                   PARM      ARCUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH
     C                   PARM      *BLANKS       PAftCUAH
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      'Y'           PACRV
     C                   PARM      *BLANKS       PELEC                                        CGL132
 
     C                   IF        ARNSDT <> *ZERO
 
     C                   EVAL      KCUST = ARCUST
     C                   EVAL      KSCDT = ARNSDT
     C                   EVAL      KSEQN = 999
     C     KACRV         SETGT     SDACRVL0
     C                   READP     SDACRVL0
 
     C                   IF        ARCUST = KCUST AND
     C                             ARSCDT = KSCDT
     C**********         EVAL      AVSEQN = ARSEQN + 1                                      MD026264
     C                   EVAL      WWSEQN = ARSEQN + 1                                      MD026264
     C                   ELSE
     C**********         EVAL      AVSEQN = 1                                               MD026264
     C                   EVAL      WWSEQN = 1                                               MD026264
     C                   ENDIF
 
     C                   CLEAR                   SDACRVDF
 
     C                   EVAL      ARCUST = KCUST
     C**********         EVAL      ARSEQN = AVSEQN                                          MD026264
     C                   EVAL      ARSEQN = WWSEQN                                          MD026264
     C                   EVAL      ARPURP = AVPURP
     C                   EVAL      ARSCDT = AVNSDT
     C                   EVAL      ARACRF = AVACRF
     C                   EVAL      ARCOMP = 'N'
 
      ** Get timestamp.
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WWTMST
     C                   MOVE      WWTMST        ARTMST
 
     C                   EVAL      ARMAGE = 'G'
     C                   EVAL      ARLTYP = 'I'
     C**********         EVAL      ARLUSR = PSUSER                                          MD028109
     C                   EVAL      ARLUSR = WKUSER                                          MD028109
     C                   EVAL      ARINDT = BJRDNB
     C                   EVAL      ARFOID = *BLANKS
 
     C                   WRITE     SDACRVD0
 
     C**********         MOVEL     ARCUST        EXDDCUST                         MD026293 MD026293A
     C**********         MOVEL     ARSCDT        EXDDSCDF                         MD026293 MD026293A
     C**********         MOVEL     ARSEQN        EXDDSEQN                         MD026293 MD026293A
     C**********         MOVEL     ARFOID        EXDDFOID                         MD026293 MD026293A
     C**********         WRITE     SDACRVEX                                       MD026293 MD026293A
     C                   EVAL      EXDDCUST = ARCUST                                       MD026293A
     C                   EVAL      EXDDSCDF = *BLANKS                                      MD026293A
     C                   MOVEL     ARSCDT        EXDDSCDF                                  MD026293A
     C                   EVAL      EXDDSEQN = %TRIML(%CHAR(ARSEQN):'0')                    MD026293A
     C                   EVAL      EXDDFOID = ARFOID                                       MD026293A
     C                   WRITE     TSDACRVD0                                               MD026293A
                                                                                            MD026293
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDAT10 - Convert YYYYMMDD Date to Midas Day                *
      *                                                               *
      *  Called by: SrIACRV, SrAACRV                                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SrZDAT10      BEGSR
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    PDateIN
     C                   PARM                    PMDNO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAACRV - Amend Account review details                       *
      *                                                               *
      *  Called by: Main Procedure                                    *
      *                                                               *
      *  Calls: *PSSR, SrZDAT10                                       *
      *                                                               *
      *****************************************************************
 
     C     SrAACRV       BEGSR
 
      ** Check first if the record exists.
 
     C                   EVAL      KCUST = AVCUST
     C                   EVAL      KSCDT = AVSCDT
     C                   EVAL      KSEQN = AVSEQN
 
     C     KACRV         CHAIN     SDACRVL0
 
     C                   IF        NOT %FOUND(SDACRVL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDACRVPD'
     C                   MOVE      AVCUST        WCUST
     C                   MOVE      AVSCDT        WSCDT
     C                   MOVE      AVSEQN        WSEQN
     C                   EVAL      DBKey = WCUST + WSCDT + WSEQN
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update 'Before Image'.
 
     C                   EVAL      WARCH = 'N'
     C                   IF        ARCOMM <> AVCOMM AND
     C                             ARCOMM <> *BLANKS
     C                   EVAL      WARCH = 'Y'
     C                   EVAL      WCOMM = ARCOMM
     C                   EVAL      WCUSC = ARCUSC
     C                   EVAL      WCDAC = ARCDAC
     C                   EVAL      WCTIC = ARCTIC
     C                   ENDIF
 
     C                   EVAL      ARPURP = AVPURP
     C                   EVAL      ARACDT = AVACDT
     C                   EVAL      ARACTM = AVACTM
     C                   EVAL      ARSCDT = AVSCDT
     C                   EVAL      ARACRF = AVACRF
     C                   EVAL      ARNSDT = AVNSDT
     C                   EVAL      ARCOMP = AVCOMP
 
      ** Get timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WWTMST
 
     C                   MOVE      *BLANKS       ARTMST
     C                   MOVE      WWTMST        ARTMST
     C                   EVAL      WWYr = %SUBST(ARTMST:01:4)
     C                   EVAL      WWMn = %SUBST(ARTMST:06:2)
     C                   EVAL      WWDy = %SUBST(ARTMST:09:2)
     C                   MOVEL     WDTMST        PDateIN
     C                   EXSR      SrZDAT10
 
     C                   EVAL      WWHH = %SUBST(ARTMST:12:2)
     C                   EVAL      WWMM = %SUBST(ARTMST:15:2)
     C                   EVAL      WWSS = %SUBST(ARTMST:18:2)
 
     C                   IF        ARCOMP = 'Y' AND
     C                             WDCOMP <> 'Y'
     C**********         EVAL      ARCUSR = PSUSER                                          MD028109
     C                   EVAL      ARCUSR = WKUSER                                          MD028109
     C**********         EVAL      ARCDAT = PMDNO                                           MD026688
     C                   EVAL      ARCDAT = BJRDNB                                          MD026688
     C                   EVAL      ARCTIM = WFTMST
     C                   ELSE
     C                   EVAL      ARCUSR = AVCUSR
     C                   EVAL      ARCDAT = AVCDAT
     C                   EVAL      ARCTIM = AVCTIM
     C                   ENDIF
 
     C                   IF        ARCOMM <> AVCOMM
     C**********         EVAL      ARCUSC = PSUSER                                          MD028109
     C                   EVAL      ARCUSC = WKUSER                                          MD028109
     C                   EVAL      ARCDAC = PMDNO
     C                   EVAL      ARCTIC = WFTMST
     C                   ENDIF
 
     C                   EVAL      ARCOMM = AVCOMM
     C                   EVAL      ARLTYP = 'A'
     C**********         EVAL      ARLUSR = PSUSER                                          MD028109
     C                   EVAL      ARLUSR = WKUSER                                          MD028109
     C                   EVAL      ARINDT = BJRDNB
 
     C                   UPDATE    SDACRVD0
 
     C                   IF        WARCH = 'Y'
     C                   EVAL      AHCUST = ARCUST
     C                   EVAL      AHSEQN = ARSEQN
     C                   EVAL      AHSCDT = ARSCDT
     C                   EVAL      AHCOMM = WCOMM
     C                   EVAL      AHCUSR = WCUSC
     C                   EVAL      AHCDAT = WCDAC
     C                   EVAL      AHCTIM = WCTIC
     C                   EVAL      AHINDT = BJRDNB
     C                   EVAL      AHTMST = ARTMST
 
     C                   WRITE     SDARCHD0
     C                   ENDIF
 
     C                   IF        ARCOMP = 'Y' AND
     C                             WDCOMP <> 'Y'
 
     C**********         CALL      'SDC009696'                                              MD026264
     C                   CALL      'SD009696'
     C                   PARM      ARCUST        PCUST
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH
     C                   PARM      *BLANKS       PAftCUAH
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      'Y'           PACRV
     C                   PARM      *BLANKS       PELEC                                        CGL132
 
     C                   IF        ARNSDT <> *ZERO
 
     C                   EVAL      KCUST = ARCUST
     C                   EVAL      KSCDT = ARNSDT
     C                   EVAL      KSEQN = 999
     C     KACRV         SETGT     SDACRVL0
     C                   READP     SDACRVL0
 
     C                   IF        ARCUST = KCUST AND
     C                             ARSCDT = KSCDT
     C                   EVAL      AVSEQN = ARSEQN + 1
     C                   ELSE
     C                   EVAL      AVSEQN = 1
     C                   ENDIF
 
     C                   CLEAR                   SDACRVDF
 
     C                   EVAL      ARCUST = KCUST
     C                   EVAL      ARSEQN = AVSEQN
     C                   EVAL      ARPURP = AVPURP
     C                   EVAL      ARSCDT = AVNSDT
     C                   EVAL      ARACRF = AVACRF
     C                   EVAL      ARCOMP = 'N'
 
      ** Get timestamp.
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WWTMST
     C                   MOVE      WWTMST        ARTMST
 
     C                   EVAL      ARMAGE = 'G'
     C                   EVAL      ARLTYP = 'I'
     C**********         EVAL      ARLUSR = PSUSER                                          MD028109
     C                   EVAL      ARLUSR = WKUSER                                          MD028109
     C                   EVAL      ARINDT = BJRDNB
     C                   EVAL      ARFOID = *BLANKS
 
     C                   WRITE     SDACRVD0
 
     C**********         MOVEL     ARCUST        EXDDCUST                         MD026293 MD026293A
     C**********         MOVEL     ARSCDT        EXDDSCDF                         MD026293 MD026293A
     C**********         MOVEL     ARSEQN        EXDDSEQN                         MD026293 MD026293A
     C**********         MOVEL     ARFOID        EXDDFOID                         MD026293 MD026293A
     C**********         WRITE     SDACRVEX                                       MD026293 MD026293A
     C                   EVAL      EXDDCUST = ARCUST                                       MD026293A
     C                   EVAL      EXDDSCDF = *BLANKS                                      MD026293A
     C                   MOVEL     ARSCDT        EXDDSCDF                                  MD026293A
     C                   EVAL      EXDDSEQN = %TRIML(%CHAR(ARSEQN):'0')                    MD026293A
     C                   EVAL      EXDDFOID = ARFOID                                       MD026293A
     C                   WRITE     TSDACRVD0                                               MD026293A
                                                                                            MD026293
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called by: Main Procedure                                    *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM                    PRetCode
 
      ** New Details in File Format
     C                   PARM                    NwARFilFmt
     C                   PARM                    WDCOMP
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C     KACRV         KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KSCDT
     C                   KFLD                    KSEQN
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     WRTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErr - Exception Errors                                      *
      *                                                               *
      *****************************************************************
 
     C     SRErr         BEGSR
 
     C                   EVAL      PRetCode = '*ERROR '
     C                   EVAL      DBPGM = 'SDACRVUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminate the Program
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
