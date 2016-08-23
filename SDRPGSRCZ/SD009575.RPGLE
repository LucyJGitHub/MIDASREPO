     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate account code for a system value')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009575 - Validate a Midas System Value for the following:  *
      *             - A valid account code (Mode = 'AC_CODE')         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CRE019             Date 15Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSC018             Date 25Jun03               *
      *                 CSD013  *CREATE    Date 08Apr03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC018 - High Availability Enhangements.                     *
      *           - Extend program mode from 10 to 190 long.          *
      *  CSD013 - New program for the System Values Development.      *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
 
      ** Midas Account Codes File
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for AcCodeVal string
     D***AcCodeVal       DS           200                                                     CGL029
     D AcCodeVal       DS           206                                                       CGL029
     D***DataToVal              1      4                                                      CGL029
     D  DataToVal              1     10                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
      ** Processing mode
     D*ProcMode*****   S             10                                                       CSC018
     D ProcMode        S            190                                                       CSC018
 
      ** General error indicator
     D GenError        S              1
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Check if the account code entered by the user is defined on
      ** the Midas account codes file
 
     C                   IF        ProcMode = 'AC_CODE   '
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C**********         PARM      DataToVal     @PFTC             4                          CGL029
     C                   PARM      DataToVal     @PFTC            10                          CGL029
     C**********         PARM      SDACOD        DSSDY                                        CRE019
     C     SDACOD        PARM      SDACOD        DSSDY                                        CRE019
 
      ** If value entered by user is not found on the Midas account codes
      ** file then return an error
 
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR0283'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
                                                                                              CRE019
      ** Return the selected field                                                            CRE019
                                                                                              CRE019
     C                   EVAL      DataToVal = *BLANKS                                        CRE019
     C                   IF        @RTCD = *BLANKS                                            CRE019
     C                   EVAL      DataToVal = A5ACCD                                         CRE019
     C                   ENDIF                                                                CRE019
     C                   IF        @RTCD = '*NOSEL'                                           CRE019
     C                   EVAL      DataToVal = *BLANKS                                        CRE019
     C                   EVAL      GenError = 'Y'                                             CRE019
     C                   ADD       1             Idx                                          CRE019
     C                   MOVEL     'USR4617'     MsgIDXArr(Idx)                               CRE019
     C                   EVAL       *INLR = *ON                                               CRE019
     C                   RETURN                                                               CRE019
     C                   ENDIF                                                                CRE019
     C                   ENDIF
 
      ** If the record is present on the Midas account codes file then peform
      ** further checks
 
      **  Check that this is a non-title account code                                         CRE019
                                                                                              CRE019
     C                   IF        ProcMode = 'AC_TITLE  '                                    CRE019
     C                             AND A5TOIN = 'Y'                                           CRE019
     C                   EVAL      GenError = 'Y'                                             CRE019
     C                   ADD       1             Idx                                          CRE019
     C                   MOVEL     'USR0183'     MsgIDXArr(Idx)                               CRE019
     C                   RETURN                                                               CRE019
     C                   ENDIF                                                                CRE019
                                                                                              CRE019
      **  Check that this is an income or expense account code                                CRE019
                                                                                              CRE019
     C                   IF        ProcMode = 'AC_INCEXP '                                    CRE019
     C                   IF        A5ACSC <> 'IN'                                             CRE019
     C                             AND A5ACSC <> 'EX'                                         CRE019
     C                             AND A5ACSC <> *BLANKS                                      CRE019
     C                   EVAL      GenError = 'Y'                                             CRE019
     C                   ADD       1             Idx                                          CRE019
     C                   MOVEL     'USR5593'     MsgIDXArr(Idx)                               CRE019
     C                   RETURN                                                               CRE019
     C                   ENDIF                                                                CRE019
     C                   ENDIF                                                                CRE019
                                                                                              CRE019
      ** Mode 'AC_CODE' - Valid account code (no further checking required)
 
     C                   IF        ProcMode = 'AC_CODE   '
     C                   EVAL      GenError = ' '
     C**********         EVAL       *INLR = *ON                                               CRE019
     C                   RETURN
     C                   ENDIF
 
      ** Catchall for unprocessed errors
 
     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Normal end processing
 
     C                   EVAL      GenError = ' '
     C**********         EVAL      *INLR = *ON                                                CRE019
 
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
     C                   PARM                    AcCodeVal
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
