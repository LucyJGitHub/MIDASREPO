     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                       CUP041
/*STD *  RPGSQLBND                                                    *                       CUP041
/*EXI *  TEXT('Midas SC Adoption program for calls frm server job')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCZONEADPT - Adoption Pgm for Calls from Server Jobs         *
      *                                                               *
      *  Function:  This program acts as an adoption program that     *
      *             runs programs called from Server jobs             *
      *                                                               *
      *  Called By: From PC/Server                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CUP041             Date 04Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 235757  *CREATE    Date 26Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *  235757 - Originally reported under BUG2634                   *
      *           This program is an adoption program which allows    *
      *           users to sign on from a PC and run programs in      *
      *           Midas which are allowed from file UPAPGMPD.         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
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
     F***UPAPGML0IF  E           K DISK                                                       CUP041
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D RecCount        S              1  0                                                    CUP041
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      *
      *  IBM
      *
      /COPY QSYSINC/QRPGLESRC,QUSEC                     Common Structure for IBM API Error Code Parm
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * The following data structure is returned by the QUSRJOBI api using JOBIO600
     D jobInfLen       S              4B 0
     D JobInf          DS           512
     D OrigUser                9     26
     D CurrentUser            92    101
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D @RTCD           S              7
     D Job             S             26
     D OrigPH          S             12
     D CurrentPH       S             12
     D UserID          S             10
     D Password        S             10
 
     D Prog            S             10
     D ParamPass       s           2900
     D length          s              4  0
     D PgmAllowed      s              3  0
 
      *****************************************************************
     D Qcmdexc         pr                  Extpgm('QCMDEXC')
     D  cmd                                like(Qcmd) Options(*Varsize) Const
     D  cmdlen                       15P 5 Const
     D  cmdopt                        3    Options(*NoPass) Const
     D Qcmd            s           3000
 
     D SndMsg1         C                   'SNDMSG ''The Program '
     D SndMsg2         C                   ' is not a -
     D                                     valid program to run'' +
     D                                     TOMSGQ(MOPERQ)'
 
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
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
     C                   eval      Job = '*                         '
      *  Set up the parameters for the QUSRJOBI api
     C                   clear                   JobInf
     C                   eval      JobInfLen = %len(JobInf)
     C                   eval      JobIntId = *blanks
 
      *  Call the API to get the Current User Information
     C                   CALL      'QUSRJOBI'                           9999
     C                   PARM                    JobInf
     C                   PARM                    JobInfLen
     C                   PARM      'JOBI0600'    APIfmt            8
     C                   PARM                    Job
     C                   PARM                    JobIntId         16
      *
     C                   MOVE      *BLANKS       PrfHandle
     C                   RESET                   QUSEC
 
      * Set the User ID to *current and the password to *blanks as it is not required
      * with *Current UserID
      * Set PrfHandle to blank before use
 
     C                   eval      UserID = '*Current'
     C                   eval      Password = *Blanks
 
     C                   CALL      'QSYGETPH'
     C                   PARM                    UserID
     C                   PARM                    Password
     C                   PARM                    PrfHandle        12
     C                   PARM                    QUSEC
 
     C                   eval      OrigPH = PrfHandle
     C                   eval      UserID = CurrentUser
     C                   eval      Password = '*NOPWD'
     C                   MOVE      *BLANKS       PrfHandle
 
     C                   CALL      'QSYGETPH'
     C                   PARM                    UserID
     C                   PARM                    Password
     C                   PARM                    PrfHandle        12
     C                   PARM                    QUSEC
 
     C                   eval      CurrentPH = PrfHandle
     C                   eval      UserID = CurrentUser
     C                   eval      Password = '*NOPWD'
     C                   MOVE      *BLANKS       PrfHandle
 
     C                   CALL      'QWTSETP'
     C                   PARM                    CurrentPH
     C                   PARM                    QUSEC
 
      **********************************************************************
      *  Program to run
 
      *  Check to see if Program can run
     C*****Prog*         Chain     UPAPGML0                                                   CUP041
     C**********         If        NOT %FOUND                                                 CUP041
     C/exec SQL                                                                               CUP041
     C+ select count(*)                                                                       CUP041
     C+ into                                                                                  CUP041
     C+   :RecCount                                                                           CUP041
     C+ from UPADPJW0                                                                         CUP041
     C+ where                                                                                 CUP041
     C+     AAPGM  = :Prog                                                                    CUP041
     C+ and AADEL  = 'N'                                                                      CUP041
     C/end-exec                                                                               CUP041
     C                   IF        RecCount = 0                                               CUP041
     C                   eval      Qcmd = SndMsg1 +
     C                             %trim(prog) +
     C                             SndMsg2
     C                   CallP(e)  Qcmdexc(Qcmd : %Len(%Trim(Qcmd)))
     C                   Else
 
      *  If the program is found on the file
     C                   eval      length = %scan(')': ParamPass)
     C                   eval      Qcmd = 'Call pgm(' +
     C                             %trim(prog) + ') ' +
     C                             %subst(ParamPass:1:length)
 
      *  Run the command
     C                   CallP(e)  Qcmdexc(Qcmd : %Len(%Trim(Qcmd)))
 
     C                   CALL      'QWTSETP'
     C                   PARM                    OrigPH
     C                   PARM                    QUSEC
 
     C                   CALL      'QSYRLSPH'
     C                   PARM                    CurrentPH
     C                   PARM                    QUSEC
 
     C                   EndIf
 
     C                   Return
 
      **********************************************************************
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
 
     C     *entry        plist
     C                   parm                    Prog
     C                   parm                    ParamPass
 
     C                   ENDSR
 
      **********************************************************************
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
