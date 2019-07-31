     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate cust number for a system value')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009575 - Validate a Midas System Value for the following:  *
      *             - A valid customer number (Mode = 'CUST_NUM')     *
      *             - A valid customer shortname (Mode = 'CUST_SNAME')*
      *             - A valid customer name or shortname              *
      *               (Mode = 'CUST_SNNUM')                           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL145             Date 10Jul13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC018             Date 25Jun03               *
      *                 CSD013  *CREATE    Date 08Apr03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL145 - Subsidiaries Daily Sweeping Forecast.               *
      *           Error in getting customer number.                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC018 - High Availability Enhangements.                     *
      *           - Extend program mode from 10 to 190 long.          *
      *  CSD013 - New program for the System Values Development.      *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
 
      ** Midas Customer File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Extra Long Data Structure for Access Objects
     D DSLDY         E DS                  EXTNAME(DSLDY)
     D/COPY OFCPYSRCZ,CGL145_001                                                              CGL145
 
      ** Data structure for CustVal string
     D CustVal         DS           200
     D  DataToVal              1     10
 
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
 
      ** Check if the customer number entered by the user is defined on
      ** the Midas customers file
 
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DataToVal     @PFTC            10
     C                   PARM                    P@KYST            7
     C/COPY OFCPYSRCZ,CGL145_002                                                              CGL145
     C                   PARM      SDCUST        DSLDY
     C/COPY OFCPYSRCZ,CGL145_003                                                              CGL145
 
      ** If value entered by user is not found on the Midas customer
      ** file then return an error
 
     C                   IF        @RTCD <> '       '
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   IF        ProcMode = 'CUST_NUM  '
     C                   MOVEL     'USR9621'     MsgIDXArr(Idx)
     C                   ENDIF
     C                   IF        ProcMode = 'CUST_SNAME'
     C                   MOVEL     'USR9622'     MsgIDXArr(Idx)
     C                   ENDIF
     C                   IF        ProcMode = 'CUST_SNNUM'
     C                   MOVEL     'USR4320'     MsgIDXArr(Idx)
     C                   ENDIF
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If the record is present on the Midas customer file then perform
      ** further checks
 
      ** If value entered by user is a customer shortname when a customer
      ** number is expected then return an error
 
     C                   IF        ProcMode = 'CUST_NUM  '
     C                   IF        P@KYST=  '*CSHT  '
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9623'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** If value entered by user is a customer number when a customer
      ** shortname is expected then return an error
 
     C                   IF        ProcMode = 'CUST_SNAME'
     C                   IF        P@KYST=  '*CNUM  '
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9624'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C/COPY OFCPYSRCZ,CGL145_004                                                              CGL145
      ** Catchall for unprocessed errors
 
     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
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
     C                   PARM                    CustVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr
 
     C/COPY OFCPYSRCZ,CGL145_005                                                              CGL145
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
