     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')

/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Gets next outgoing payment referece')         *


      *  Midas - Standard subprograms                                 *

      *  FTOPAY2RV - Retrieve the next outgoing payment reference     *

      *  Function : This module will create the next outgoing payment *
      *             reference number and pass to calling program.     *

      *  (c) Finastra International Limited 2001                      *

      *  Last Amend No. JMI106             Date 24May18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT151             Date 21Mar14               *
      *                 AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24774           Date 06Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 15Jul99               *
      *                                    Date ddmmmyy               *

      *---------------------------------------------------------------*
      *                                                               *
      *  JMI106 - Split FT Sequence Number based on Settlement Type   *
      *           Use of core hook FTH00069                           *
      *           Addition of hook JMI106_013                         *
      *           Addition of hook JMI106_014                         *
      *           (Upgrade to FB Midas)                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00067                                 *
      *             WNCPYSRC,FTH00068                                 *
      *             WNCPYSRC,FTH00069                                 *
      *             WNCPYSRC,FTH00070                                 *
      *             WNCPYSRC,FTH00106                                 *
      *             WNCPYSRC,FTH00107                                 *
      *  BUG24774 - Error on FTOPAY2RV when authorizing a transaction.*
      *             Applied fix core 227607.                          *
      *  227607 - Error on FTOPAY2RV when more than 2 RFT details     *
      *           generate OPs.                                       *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Program, procedure and module names for parameters
      ** ==================================================

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

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT151
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CFT151
     D*OTPAYD**      E DS                  EXTNAME(OTPAYDA)                                   CFT151
      ** DS for next Outgoing Payment Reference Number                                        CFT151
     D OTPAYD          DS             4                                                       CFT151
     D  WOTSQ                  1      4  0                                                    CFT151

     D/COPY WNCPYSRC,FTH00067
     DP_Ref_Ds         DS
     D @@P                     1      1
     D @@Date                  2      7
     D @@P_Ref                 8     11
     D @@OP                   12     13
     D @@Sett                 14     15
     D/COPY WNCPYSRC,JMI106_013                                                               JMI106

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     DTemp_Char                       8
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   reset                   RetCodeIn

      *
      ** Get todays date in format of YYMMDD from ZA3344
      *
     C                   CallB     'ZA3344'
     C                   Parm      *Zeros        Filler0           6 0
     C                   Parm      *Blanks       Filler1           7
     C                   Parm      *Zeros        Filler2           8 0

     C                   Movel     *Blanks       Temp_Char                                    227607
     C                   Eval      @@P = 'P'                                                  227607
     C                   Eval      @@OP = 'OP'                                                227607
     C                   Eval      @@Sett='08'                                                227607
      *
      ** Capture date
      *
     C                   movel     Filler2       Temp_Char
     C     6             Subst     Temp_Char:3   @@Date

      *
      ** Move dataarea data to payments datastructure
      *
     C/COPY WNCPYSRC,FTH00068
     C                   IF        CFT151 = 'N'                                               CFT151
     C***  *lock         IN        OTPAYDA                                             227607 CFT151
     C     *lock         IN        OTPAYD                                                     CFT151
     C*********          Movel     Osqnm         @@P_Ref                                      CFT151
     C                   MOVEL     WOTSQ         @@P_Ref                                      CFT151
     C*********          Eval      Osqnm = Osqnm + 1                                          CFT151
     C                   Eval      WOTSQ = WOTSQ + 1                                          CFT151
     C****               Out       OTPAYDA                                                    CFT151
     C                   Out       OTPAYD                                                     CFT151
     C                   ELSE                                                                 CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD             7                          CFT151
     C                   PARM      'OT'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC             1                          CFT151
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    @@P_Ref                                      CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   ENDIF                                                                CFT151
     C/COPY WNCPYSRC,FTH00069

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    P_Ref_Ds

     C**********         Movel     *Blanks       Temp_Char                                    227607
     C**********         Eval      @@P = 'P'                                                  227607
     C**********         Eval      @@OP = 'OP'                                                227607
     C**********         Eval      @@Sett='08'                                                227607

     C/COPY WNCPYSRC,FTH00070
      *
      ** Define outgoing payments dataarea
      *
     C**** *DTAARA       DEFINE                  OTPAYDA
     C     *DTAARA       DEFINE    OTPAYDA       OTPAYD                                       CFT151
     C/COPY WNCPYSRC,FTH00106
     C******lock*********IN        OTPAYDA                                                    227607
     C/COPY WNCPYSRC,FTH00107

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *                                                                                       CFT151
      * Access SAR details file to see if CFT151 is installed.                                CFT151
      *                                                                                       CFT151
     C                   CALLB     'AOSARDR0'                                                 CFT151
     C                   PARM      *BLANKS       @RTCD             7                          CFT151
     C                   PARM      '*VERIFY'     @OPTN             7                          CFT151
     C                   PARM      'CFT151'      @SARD             6                          CFT151
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
                                                                                              CFT151
     C                   IF        @RTCD = *BLANKS                                            CFT151
     C                   MOVEL     'Y'           CFT151            1                          CFT151
     C                   ELSE                                                                 CFT151
     C                   MOVEL     'N'           CFT151                                       CFT151
     C                   ENDIF                                                                CFT151
     D/COPY WNCPYSRC,JMI106_014                                                               JMI106

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***

      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
