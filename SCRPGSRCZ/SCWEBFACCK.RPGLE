     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Chk if running in a WebFacing environment')
      *****************************************************************
      *                                                               *
      *  Midas - System Control module                                *
      *                                                               *
      *  SCWEBFACCK - Check if Running in a WebFacing Environment     *
      *                                                               *
      *  Function:  This module check if the job is running in a      *
      *             WebFacing environment or not.                     *
      *             Some functions need to call different programs    *
      *             depending upon the environment.                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAAA02  *CREATE    Date 28Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAAA02 - The control CL will use this fucntion to determine  *
      *           whether the job is running in a WebFacing           *
      *           environment or not.                                 *
      *                                                               *
      *****************************************************************
 
     D QQFENV          PR            10I 0 Extproc('QqfEnvironment')
 
     d Response        s             10I 0
     d Webfacing       s              1a
 
     d @RUN            s              1a
 
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
      /free
         Response = QQFENV;
 
         if Response = 1;
            Webfacing = 'Y';
         else;
            Webfacing = 'N';
         endif;
 
         return;
 
      /end-free
 
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
     C                   PARM                    WebFacing
 
     C                   ENDSR
 
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
