     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate MT10350* system values')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009900 - Validate Midas System Value for the following:    *
      *             - MT10350KIBAN                                    *
      *             - MT10350KRetailNumber                            *
      *             - MT10350KGLAccountRef                            *
      *             - MT10350KAccountName                             *
      *             - MT10350KCustAddr                                *
      *             - MT10350K_7_TaxC                                 *
      *             - MT202COV50x_AcFmt                               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1094263          Date 22Mar13               *
      *                 CFT124  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1094263 - Corrected system value validation as per v1.01   *
      *              version of CFT120 FDS                            *
      *  CFT124 - Ordering Customer of MT103 50K - 'Account' Formats  *
      *                                                               *
      *****************************************************************
 
      ** Data structure for NewCurrVal string
     D NewCurrVal      DS           200
     D  DataToVal              1      1
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
      ** Processing mode
     D ProcMode        S            190
 
      ** General error indicator
     D GenError        S              1
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
 
     DSysValIBAN       S             20    INZ('MT10350KIBAN')
     DSysValACNO       S             20    INZ('MT10350KRetailNumber')
     DSysValGLRF       S             20    INZ('MT10350KGLAccountRef')
     DSysValNAME       S             20    INZ('MT10350KAccountName')
     DSysValCADD       S             20    INZ('MT10350KCustAddr')
     DSysValCTAX       S             20    INZ('MT10350K_7_TaxC')
     DSysValAFMT       S             20    INZ('MT202COV50x_AcFmt')
 
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** External data structure for Switchable features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   SELECT
 
     C     SystemValue   WHENEQ    SysValIBAN
     C     SystemValue   OREQ      SysValACNO
     C     SystemValue   OREQ      SysValGLRF
     C     SystemValue   OREQ      SysValCADD
     C     SystemValue   OREQ      SysValCTAX
     C     SystemValue   OREQ      SysValAFMT
 
     C     SystemValue   IFEQ      SysValCTAX                                              AR1094263
     C     P@VL05        ANDNE     'Y'                                                     AR1094263
     C                   EVAL      GenError = 'Y'                                          AR1094263
     C                   ADD       1             Idx                                       AR1094263
     C                   MOVEL     'CFT1243'     MsgIDXArr(Idx)                            AR1094263
     C                   EVAL       *INLR = *ON                                            AR1094263
     C                   RETURN                                                            AR1094263
     C                   ENDIF                                                             AR1094263
                                                                                           AR1094263
     C     DataToVal     IFNE      'Y'
     C     DataToVal     ANDNE     'N'
     C     DataToVal     ANDNE     *BLANKS
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CFT1241'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C     SystemValue   IFEQ      SysValIBAN
     C     CFT004        ANDNE     'Y'
     C**********         MOVE      *BLANKS       DataToVal                                 AR1094263
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CFT1242'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C     SystemValue   IFEQ      SysValIBAN                                              AR1094263
     C     SystemValue   OREQ      SysValACNO                                              AR1094263
     C     SystemValue   OREQ      SysValGLRF                                              AR1094263
     C     DataToVal     IFEQ      'Y'
     C     P@VL04        ANDEQ     'Y'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CFT1240'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF                                                             AR1094263
     C                   ENDIF
 
     C     SystemValue   WHENEQ    SysValNAME
 
     C     DataToVal     IFNE      'Y'
     C     DataToVal     ANDNE     'N'
     C     DataToVal     ANDNE     *BLANKS
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CFT1241'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C     DataToVal     IFEQ      'Y'
     C     P@VL01        ANDEQ     'Y'
     C     DataToVal     OREQ      'Y'
     C     P@VL02        ANDEQ     'Y'
     C     DataToVal     OREQ      'Y'
     C     P@VL03        ANDEQ     'Y'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CFT1240'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSL
 
      ** Normal end processing
 
     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    NewCurrVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr
 
      ** Access System value MT10350KNAME
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode          7
     C                   PARM      SysValIBAN    P@OP01           20
     C                   PARM      *BLANKS       P@VL01          200
     C                   PARM      SysValACNO    P@OP02           20
     C                   PARM      *BLANKS       P@VL02          200
     C                   PARM      SysValGLRF    P@OP03           20
     C                   PARM      *BLANKS       P@VL03          200
     C                   PARM      SysValNAME    P@OP04           20
     C                   PARM      *BLANKS       P@VL04          200
     C                   PARM      SysValCADD    P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      SysValCTAX    P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      SysValAFMT    P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200
 
     C                   IF        PRetCode  <> *BLANKS
     C                   EVAL      DBPGM = 'SD009900'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEy = '*KEY   '
     C                   EVAL      DBase = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CFT004'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CFT004'
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      'Y'           CFT004            1
     C                   ELSE
     C                   EVAL      CFT004 = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
