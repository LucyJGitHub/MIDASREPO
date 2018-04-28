     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Format Time as xx:xx:xx characters')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTTIMECHAR - Format Time Characters                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CFT009  *CREATE    Date 09Jun00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT009 - Funds Transfer Fees and Charges                     *
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
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
     D TimeDS          DS
     D  Hours                  1      2
     D  Col1                   3      3
     D  Minutes                4      5
     D  Col2                   6      6
     D  Seconds                7      8
 
     D   HH1                   1      1
     D   HH2                   2      2
     D   MM1                   4      4
     D   MM2                   5      5
     D   SS1                   7      7
     D   SS2                   8      8
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D @CHK            C                   CONST('0123456789:')
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TimeChar        S              8
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
     C                   EVAL      RetCodeIn = *Blanks
 
     C                   Exsr      FirstCheck
 
     C                   Movel     TimeChar      TimeDS
 
      * Ensure that valid entry
     C     HH1           SCAN      @CHK          I                 3 0
     C                   IF        I = 0 and HH1 <> *Blank
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     HH2           SCAN      @CHK          I                 3 0
     C                   IF        I = 0 and HH2 <> *Blank
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     MM1           SCAN      @CHK          I                 3 0
     C                   IF        I = 0 and MM1 <> *Blank
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     MM2           SCAN      @CHK          I                 3 0
     C                   IF        I = 0 and MM2 <> *Blank
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     SS1           SCAN      @CHK          I                 3 0
     C                   IF        I = 0 and SS1 <> *Blank
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     SS2           SCAN      @CHK          I                 3 0
     C                   IF        I = 0 and SS2 <> *Blank
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     COL1          SCAN      @CHK          I                 3 0
     C                   IF        I = 0 and COL1 <> *Blank
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     COL2          SCAN      @CHK          I                 3 0
     C                   IF        I = 0 and COL2 <> *Blank
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
      * =========================================================
      * Length = 8 and no :
     C                   If        Seconds <> *Blanks and
     C                             Col1 <> ':'        and
     C                             Col2 <> ':'
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
      * =========================================================
      * Format Time
     C                   If        RetCodeIn = *Blanks
     C                   Exsr      FmtTime
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
     C     FmtTime       Begsr
 
      * Format time.
 
     C                   Eval      Hours = %Subst(TimeChar:1:2)
 
     C                   IF        %Subst(TimeChar:3:1) = ':'
     C                   Eval      Minutes = %Subst(TimeChar:4:2)
     C                   Else
     C                   Eval      Minutes = %Subst(TimeChar:3:2)
     C                   Endif
 
     C                   IF        %Subst(TimeChar:5:1) = ':'
     C                   Eval      Seconds = %Subst(TimeChar:6:2)
     C                   Else
     C                   IF        %Subst(TimeChar:6:1) = ':'
     C                   Eval      Seconds = %Subst(TimeChar:7:2)
     C                   Else
     C                   Eval      Seconds = %Subst(TimeChar:5:2)
     C                   Endif
     C                   Endif
 
     C                   If        Hours   = *Blanks
     C                   Eval      Hours   = Minutes
     C                   Eval      Minutes = Seconds
     C                   Eval      Seconds = '00'
     C                   Else
     C                   If        Minutes = *Blanks
     C                   Eval      Minutes = Seconds
     C                   Eval      Seconds = '00'
     C                   Else
     C                   If        Seconds = *Blanks
     C                   Eval      Seconds = '00'
     C                   Endif
     C                   Endif
     C                   Endif
 
     C                   Exsr      CheckBl
 
     C                   Eval      TimeChar = TimeDS
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
     C     CheckBl       Begsr
 
     C                   IF        HH1 = *Blank
     C                   Eval      HH1 = '0'
     C                   Endif
 
     C                   IF        HH2 = *Blank
     C                   Eval      HH2 = '0'
     C                   Endif
 
     C                   IF        MM1 = *Blank
     C                   Eval      MM1 = '0'
     C                   Endif
 
     C                   IF        MM2 = *Blank
     C                   Eval      MM2 = '0'
     C                   Endif
 
     C                   IF        SS1 = *Blank
     C                   Eval      SS1 = '0'
     C                   Endif
 
     C                   IF        SS2 = *Blank
     C                   Eval      SS2 = '0'
     C                   Endif
 
     C                   EVAL      COL1 = ':'
     C                   EVAL      COL2 = ':'
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
     C     FirstCheck    Begsr
 
     C     '::'          Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ': :'         Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':  :'        Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':   :'       Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':    :'      Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':     :'     Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':      :'    Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':       '    Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':      '     Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':     '      Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':    '       Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':   '        Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C     ':  '         Scan      TimeChar:1    I
     C                   If        I <> 0
     C                   Eval      RetCodeIn = '*ERROR'
     C                   Endif
 
     C                   If        RetCodeIn <> *Blanks
     C                   Return
     C                   Endif
 
     C                   Endsr
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
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    TimeChar
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
