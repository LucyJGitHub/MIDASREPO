     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IBAN Number')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVIBNB01 - Validate IBAN Number                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 18Oct99               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D PIBAN           S             47
     D POWITH          S             47
     D PONOBL          S             34
     D P@IBAN          S             34

     D @Type           S              2
     D IBAN            S             35

     D CFT004          S              1

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

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

     C                   If        CFT004 <> 'Y'
     C                   Eval      RetCodeIn = '*NOTINST  '
     C                   Return
     C                   Endif

     C                   If        %Subst(IBAN:1:1) = '/'
     C     34            Subst     IBAN:2        PIBAN
     C                   Else
     C                   Eval      PIBAN = IBAN
     C                   Endif

      * Call AOIBANR3 to reformat variable if required
     C                   CallB     'AOIBANR3'
     C                   Parm                    @RTCD
     C                   Parm                    PIBAN
     C                   Parm                    POWITH
     C     P@IBAN        Parm                    PONOBL

      * Check to see if valid IBAN according to whether RO/BO or RI/BI

     C                   Select

      * Validate EXTERNAL Iban
     C                   When      @Type = 'RO' or
     C                             @Type = 'BO'
     C                   Call      'AOIBANR5'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm                    P@IBAN

     C                   Select
     C                   When      @RTCD = *Blanks
     C                   Eval      RetCodeIn = '*VALIDOUT '
     C                   When      @RTCD = '      1'
     C                   Eval      RetCodeIn = '*NOTIBAN  '
     C                   Other
     C                   Eval      RetCodeIn = '*INVALIDOT'
     C                   Endsl

      * Validate INTERNAL IbanR2
     C                   When      @Type = 'RI' or
     C                             @Type = 'BI'
     C                   CallB     'AOIBANR2'
     C                   Parm                    @RTCD
     C                   Parm                    P@IBAN
     C                   Parm                    DSSDY

      * 1 = Invalid Country.
     C                   Select
     C                   When      @RTCD = *Blanks
     C                   Eval      RetCodeIn = '*VALIDIN  '
     C                   When      @RTCD = '      1'
     C                   Eval      RetCodeIn = '*NOTIBAN  '
     C                   Other
     C                   Eval      RetCodeIn = '*INVALIDIN'
     C                   Endsl

     C                   Endsl

      ** Return
     C                   Return

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

     C     *Entry        PLIST
     C                   Parm                    RetCodeIn
     C                   Parm                    @Type
     C                   Parm                    IBAN

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFT004'      @Sard
     C                   PARM                    Dsfdy
      *
     C                   IF        @Rtcd = *BLANKS
     C                   MOVE      'Y'           CFT004
     C                   ELSE
     C                   IF        @Rtcd = '*NRF'
     C                   MOVE      'N'           CFT004
     C                   ELSE
     C                   EVAL      Dbfile = 'SCSARDPD'
     C                   EVAL      DBase = 1
     C                   EVAL      Dbkey = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

      *  Program, module and procedure names for database error processing.*
      *  The following /COPY sets these values, and also defines LDA as    *
      *  an external data area                                             *
     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***

      *****************************************************************
      /EJECT
      **********************************************************************

     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
