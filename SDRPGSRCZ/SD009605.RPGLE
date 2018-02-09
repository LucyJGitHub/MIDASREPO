     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Encrypt Password of SQL Server')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data  Module                                *
      *                                                               *
      *  SD009605 - Midas SD Encrypt Password of SQL Server           *
      *                                                               *
      *  Function:  This program will encrypt the password the user   *
      *             has set-up from the system value maintenance      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD028  *CREATE    Date 22Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD028 - KYC (Standing Data Authorisations)                  *
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Area giving Installation Control Details
 
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
     D PSystemVal      S             20
     D PNewValue       S            200
     D PProcMode       S            190
     D PGenError       S              1
     D PIdx            S              2  0
     D PMsgIDXArr      S              7
 
      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
      ** Prototype for a Java String object
     D crtString       PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             *CONSTRUCTOR)
     D                                     CLASS(*JAVA:'java.lang.String')
     D  bytes                      7640A   CONST VARYING Options(*VarSize)
 
      ** Trim leading spaces
     D  TrimJavaStr    Pr              O   ExtProc( *JAVA: 'java.lang.String':
     D                                              'trim' )
     D                                     Class( *JAVA: 'java.lang.String' )
      ** Convert to RPG string
     D  ToRpgStr       PR          9999A   ExtProc( *JAVA: 'java.lang.String':
     D                                              'getBytes' )
     D                                     VARYING
 
      ** Prototype for method
     D getValues       PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     util.KycInterfaceUtility':
     D                                     'getEncryptedValue')
     D                                     STATIC
     D                                     CLASS(*JAVA:'java.lang.String')
     D   String2                       O   CLASS(*JAVA:'java.lang.String')
 
      ** Create string objects
     D Parm1           S               O   CLASS(*JAVA:'java.lang.String')
     D String1         S               O   CLASS(*JAVA:'java.lang.String')
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
      ** Call Set-up ClassPath program
 
     C                   CALL      'SDC009605'
 
     C                   IF        *INU7 = *Off and *INU8 = *Off
 
      ** Create java string objects for all parameters
 
     C                   EVAL      String1   = crtString(PNewValue)
     C                   EVAL      String1   = TrimJavaStr(String1)
 
      ** Invoke the KYC method of the KYCClass object
 
     C                   EVAL      Parm1     = getValues(String1)
     C                   EVAL      PNewValue = ToRpgStr(Parm1)
     C                   ENDIF
 
     C                   EVAL      *INLR   = *ON
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
     C                   PARM                    PSystemVal
     C                   PARM                    PNewValue
     C                   PARM                    PProcMode
     C                   PARM                    PGenError
     C                   PARM                    PIdx
     C                   PARM                    PMsgIDXArr
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
 
     C                   ENDSR
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
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
