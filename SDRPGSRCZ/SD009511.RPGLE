     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate entry for JRNCache system value')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009511 - Midas SD Validate entry for JRNCache system value *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD023896           Date 06May14               *
      *  Prev Amend No. CSC048  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023896 - Removed PRDID(5761SS1) parameter in DSPLICKEY so  *
      *             it will work on other OS version                  *
      *  CSC048 - Journal Caching                                     *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Data structure for NewVal string
     D NewVal          DS           200
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
 
      ** Parameter for calling QCMDEXC
     D QCMDLEN         S             15P 5 INZ(85)
     D QCMD            S             85
     D QTXT            S            100    DIM(1) CTDATA PERRCD(1)
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Validate if the entered value is 'Y' or 'N'
 
     C                   IF        DataToVal <> 'Y'
     C                             and DataToVal <> 'N'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR4620'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If entered value is 'Y', validate if the
      ** IBM feature Journal Caching is available
 
     C                   IF        DataToVal = 'Y'
     C                   EVAL      QCMD = QTXT(1)
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    QCMD
     C                   PARM                    QCMDLEN
 
      ** If error was encountered, send message
      ** 'Journal Caching is not available'
 
     C                   IF        %ERROR
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR4637'     MsgIDXArr(Idx)
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Normal end processing
 
     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
 
     C                   PARM                    SystemValue
 
      ** Value entered by user
 
     C                   PARM                    NewVal
 
      ** Processing Mode
 
     C                   PARM                    ProcMode
 
      ** General Error Indicator
 
     C                   PARM                    GenError
 
      ** Error message ID (number of entries)
 
     C                   PARM                    Idx
 
      ** Error message ID (array)
 
     C                   PARM                    MsgIDXArr
 
     C                   ENDSR
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
      *****************************************************************
**  QTXT
DSPLICKEY FEATURE(5117) OUTPUT(*LICKEYFILE) LICKEYFILE(QTEMP/LICKEY)                        MD023896
