     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Payment Date Offset Codes PROMPT')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000960 - Select Payment Charge Offset Code                 *
      *                                                               *
      *  Function : This program is a prompt program for Payment      *
      *             Charge Offset Code.                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG433             Date 02Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 01May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG433 - Recompiled due to change in FTPDOCPD                *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
     FFT000960DFCF   E             WORKSTN SFILE(FT960S1:SFLRRN)
     FFTPDOCL0  IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** � Automatically included D-specs       �
      ** � ==============================       �
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
      ** � End of automatically included D-specs�
      ** � =====================================�
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** � Manually included D-specs            �
      ** � =========================            �
      ** +--------------------------------------+
     DP#PYDTOC         S                   Like(PYDTOC)
 
     DMSGDS            DS
     D  Msgid                  1      7
     D  Msgf                   8     17    Inz('FTUSRMSG')
     D  Msglib                18     27    Inz('*LIBL')
     D  MsgDta                28    283    Inz(' ')
     D  MsgRel               284    288    Inz('*SAME')
 
 
      ** +--------------------------------------+
      ** � Arrays and Data Structures           �
      ** � ==========================           �
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** � Named constants                      �
      ** � ===============                      �
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** � Declared variables                   �
      ** � ==================                   �
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** � End of D-specs                       �
      ** � ==============                       �
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** �                                                                �
      ** � Initial processing is performed automatically: the *INZSR is   �
      ** � executed at program activation.                                �
      ** �                                                                �
      ** +----------------------------------------------------------------+
 
 
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
 
     C                   Dow       *Inkl = *Off
     C                   Write     MsgCtl
     C                   Write     FT960T1
     C                   Exfmt     FT960C1
      *
     C                   CALL      'ZA0250'
 
      * If control record (positioner) changed, reload
     C                   If        *In60
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
     C                   Else
      * Sfldsp = 30.  ie records exist, then can process
     C                   If        *In30 = *On
     C                   Exsr      Prc@Sf
     C                   Endif
     C                   Endif
 
     C                   Enddo
 
     C                   Eval      *Inlr = *On
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr@Sf - Clear Subfile                                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr@Sf        Begsr
      * Clear Subfile
     C                   Seton                                          3031
     C                   Write     FT960C1
     C                   Setoff                                         3031
      *
      * Reset SFLRRN
     C                   Eval      Sflrrn = *Zero
     C                   Endsr
      *****************************************************************
      *                                                               *
      * Load@sf - Load subfile data                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Load@sf       Begsr
     C                   Setoff                                           32
 
     C                   If        PosCde <> *Blanks
     C     PosCde        Setll     FTPDOCL0                           75  77
     C                   Select
     C                   When      *In75
     C                   ReadP     FTPDOCL0                               77
     C     PYDTOC        Setll     FTPDOCL0
     C                   Endsl
     C                   Else
     C     *Loval        Setll     FTPDOCL0
     C                   Endif
      *
      * Read Records into Subfile
     C                   Read      FTPDOCL0                               32
     C                   Dow       *In32 = *Off
     C                   Eval      Sflrrn = Sflrrn + 1
     C                   Write     FT960S1
     C                   Read      FTPDOCL0                               32
     C                   Enddo
      *
      * Compare SFLRRN with 0 to see if there is anything to display
     C                   If        Sflrrn > 0
     C                   Eval      *in30 = *On
     C                   Else
     C                   Eval      Msgid = 'GEN0001'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Prc@Sff - Process Subfile                                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Prc@Sf        Begsr
      *
      * Read subfile for any subfile select records
     C                   Eval      *In33 = *Off
     C                   Readc     FT960S1                                33
     C                   Dow       *In33 = *Off
 
     C     SflRrn        Chain     FT960S1                            44
     C                   Eval      *In43 = *Off
     C                   Update    FT960S1
 
     C                   Setoff                                         1012
     C                   Select
      * Change current record
     C     Sflsel        Wheneq    '1'
     C                   Eval      P#PYDTOC = PYDTOC
     C                   Eval      *InKL = *On
     C                   Leave
      *
      * If subfile select != 1 then Error Message
     C                   Other
     C     SflSel        Ifne      *BLANK
     C                   Eval      *in34 = *On
     C                   Eval      MsgDta = SflSel
     C                   Eval      Msgid = 'FTM1001'
     C                   Exsr      SndMsg
     C                   Eval      *in43 = *On
     C     SflRrn        Chain     FT960S1                            44
     C                   Update    FT960S1
     C                   Endif
      *
     C                   Endsl
      *
     C                   Readc     FT960S1                                33
     C                   Enddo
     C                   Endsr
      *****************************************************************
      *                                                               *
      * SndMsg - Send Program Message                                 *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SndMsg        Begsr
      *
      * Only write message if requested
     C                   If        Msgid <> *Blanks
     C                   CallB     'AOCREPT'
     C                   Parm                    Msgid
     C                   Parm                    Msgf
     C                   Parm                    MsgLib
     C                   Parm                    MsgDta
     C                   Parm                    MsgRel
     C                   Parm                    #Pgm
     C                   PARM      *Blanks       FTMSGQ           10
     C                   PARM      *Blanks       FTMSGT            7
     C                   Endif
      *
      * Reset message Id
     C                   Reset                   Msgds
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
     C                   Parm                    P#PYDTOC
 
     C                   Eval      #Pgm = 'FT000960'
 
 
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
(c) Finastra International Limited 2001
