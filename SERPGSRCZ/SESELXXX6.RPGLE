     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE SECS - Initial - LU/ER Window')
      *****************************************************************
      *                                                               *
      *  Midas - European reporting - Luxembourg                      *
      *                                                               *
      *  SESELXXX6 - Securities Details - Setup PF/SECTYDX6           *
      *                                                               *
      *  Function:  This program defaults extension detail for        *
      *             European reporting.                               *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 05May06               *
      *                 CER001             Date 25Apr05               *
      *                 ULX046  *CREATE    Date 17Oct02               *
      *                 207361             Date 10Jul02               *
      *                 169521             Date 29Dec00               *
      *                 ULX008             Date 20Jul00               *
      *                 ULX008             Date 24Feb00               *
      *                 ERL371             Date 13Oct93               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  207361 - Window not displayed anymore in Release 4           *
      *  ULX046 - Circulars 2002/170-174-175 Integration              *
      *           This program corresponds to SE0040X6                *
      *  169521 - A new field "voting right" has been added to SECYDX6*
      *           to report it to IML.                                *
      *  ULX008 - CSSF Statutory Reporting : Commissariat aux Bourses *
      *           Change Control C                                    *
      *  ULX008 - CSSF Statutory Reporting : Commissariat aux Bourses *
      *  ERL371 - IML 1.4 DEVELOPMENT                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
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
 
     FSECTYD    IF   E             DISK    INFSR(*PSSR)
     F***SECTYDY6  UF A E           K DISK    INFSR(*PSSR)                                    CER001
     FSESDX3L0  UF A E           K DISK    INFSR(*PSSR)                                       CER001
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D @ReturnIn       S              7
     D @ModeIn         S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   IF        @ModeIn = '1'                                First run
     C                             OR @ModeIn = '2'                             Next run
 
     C                   READ      SECTYD
 
     C                   DOW       Not %EOF(SECTYD)
 
     C*****SESN*         CHAIN     SECTYDY6                                                   CER001
     C     SESN          CHAIN     SESDX3L0                                                   CER001
 
      ** If the record exists, check if fields have been coorrectly defaulted.
 
     C**********         IF        %Found(SECTYDY6)                                           CER001
     C                   IF        %Found(SESDX3L0)                                           CER001
 
     C                   IF        VVSUBR = *BLANKS
     C                   EVAL      VVSUBR = 'N'
     C                   ENDIF
 
     C                   IF        VVQUOT = *BLANKS
     C                   EVAL      VVQUOT = 'Y'
     C                   ENDIF
 
     C                   UPDATE    SECTYDF6
 
     C                   ELSE
 
      ** If the record does not exist, add details.
 
     C                   EVAL      VVSESN = SESN
     C                   EVAL      VVSECT = 0
     C                   EVAL      VVLUSU = 0                                    ERL371
     C                   EVAL      VVLURA = 0                                    ERL371
     C                   EVAL      VVIM93 = 0                                    ERL371
     C                   EVAL      VVCLAT = 0                                    ERL371
     C                   EVAL      VVSUBR = 'N'                                  ERL371
     C                   EVAL      VVROFC = *BLANKS
     C                   EVAL      VVRATC = *BLANKS
     C                   EVAL      VVSECD = *BLANKS                              ULX008
     C                   EVAL      VVSNCD = *BLANKS                              ULX008
     C**D***             EVAL      VVEEEM = *BLANKS                       ULX008 207361
     C                   EVAL      VVEEEM = 'N'                                  207361
     C                   EVAL      VVVOTR = 0                                    169521
     C                   EVAL      VVQUOT = 'Y'
 
     C                   WRITE     SECTYDF6
 
     C                   ENDIF
 
     C                   READ      SECTYD
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   SETON                                        LR
 
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
 
     C     *entry        PLIST
     C                   PARM                    @ReturnIn
     C                   PARM                    @ModeIn
 
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
