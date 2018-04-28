     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Flag an onrequest component to run in COB')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Module                             *
      *                                                               *
      *  CB000104 - Flag an On Request Component to Run in COB        *
      *                                                               *
      *  Function:  This program writes a record to CBCOBRPD to       *
      *             flag a component to run in the next COB.          *
      *                                                               *
      *  Called By: Main Midas menu                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 204813  *CREATE    Date ddmmmyy               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  204813 - New program to write on request COB components.     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    99         Chain fail on CBCOBRL0                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCBCOBRL0  IF A E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @Run            S              1
     D Component       S             10
     D CompSeq         S              5
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Prepare common parameters for Midas Information Screen
 
     C                   MOVEL     'CB000104'    FPGM
     C                   MOVEL     'SCC0010'     CALLED
     C                   MOVEL     'ENTER'       OPTION
     C                   MOVEL     ' '           REPLY
      *
      ** Check whether the intended record already exists
 
     C     KeyListCOBR   CHAIN     CBCOBRL0                           9999
 
      ** If the record already exists inform the user
 
     C     *IN99         IFEQ      *OFF
 
     C                   MOVEL     'CBM0011'     MSG5
 
     C                   CALL      'UTC1000'
     C                   PARM                    RTNCDE           10
     C                   PARM                    FPGM             10
     C                   PARM                    MSG1              7
     C                   PARM                    MSG2              7
     C                   PARM                    MSG3              7
     C                   PARM                    MSG4              7
     C                   PARM                    MSG5              7
     C                   PARM                    MSG6              7
     C                   PARM                    MSG7              7
     C                   PARM                    MSG8              7
     C                   PARM                    MSG9              7
     C                   PARM                    MSG10             7
     C                   PARM                    HLPIND            2 0
     C                   PARM                    CALLED           10
     C                   PARM                    OPTION           10
     C                   PARM                    REPLY             1
 
     C                   ENDIF
 
      ** If the record does not exist
      ** write out the new record to CBCOBRL0
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      CRCOTT = Component
     C                   EVAL      CRCSEQ = CompSeq
     C                   WRITE     @COBRL0
 
      ** Inform user that the request was successful
 
     C                   MOVEL     'CBM0009'     MSG5
 
     C                   CALL      'UTC1000'
     C                   PARM                    RTNCDE           10
     C                   PARM                    FPGM             10
     C                   PARM                    MSG1              7
     C                   PARM                    MSG2              7
     C                   PARM                    MSG3              7
     C                   PARM                    MSG4              7
     C                   PARM                    MSG5              7
     C                   PARM                    MSG6              7
     C                   PARM                    MSG7              7
     C                   PARM                    MSG8              7
     C                   PARM                    MSG9              7
     C                   PARM                    MSG10             7
     C                   PARM                    HLPIND            2 0
     C                   PARM                    CALLED           10
     C                   PARM                    OPTION           10
     C                   PARM                    REPLY             1
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
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
     C                   PARM                    Component
     C                   PARM                    CompSeq
 
      ** Key list for CBCOBRL0
 
     C     KeyListCOBR   KLIST
     C                   KFLD                    Component
     C                   KFLD                    CompSeq
      *
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @Run = *BLANK
     C                   EVAL      @Run = 'Y'
     C                   DUMP
 
      ** Inform user that the request was unsuccessful
 
     C                   MOVEL     'CBM0010'     MSG5
 
     C                   CALL      'UTC1000'
     C                   PARM                    RTNCDE           10
     C                   PARM                    FPGM             10
     C                   PARM                    MSG1              7
     C                   PARM                    MSG2              7
     C                   PARM                    MSG3              7
     C                   PARM                    MSG4              7
     C                   PARM                    MSG5              7
     C                   PARM                    MSG6              7
     C                   PARM                    MSG7              7
     C                   PARM                    MSG8              7
     C                   PARM                    MSG9              7
     C                   PARM                    MSG10             7
     C                   PARM                    HLPIND            2 0
     C                   PARM                    CALLED           10
     C                   PARM                    OPTION           10
     C                   PARM                    REPLY             1
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
