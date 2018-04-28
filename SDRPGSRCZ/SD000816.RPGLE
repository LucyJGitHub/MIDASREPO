     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD EC Types Maintenance')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000816 - Midas SD Exemption Certificate Types Maintenance  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. AR797240           Date 30Jun11               *
      *  Prev Amend No. AR795895           Date 27Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22516           Date 09Feb09               *
      *                 BUG22515           Date 30Jan09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR797240 - New standing data tables available in the         *
      *             maintenance menu are not available in the         *
      *             enquiry menu                                      *
      *  AR795895 - INCONSISTENT MENU OPTION (I-013) (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22516 - Exemption Certificates -Screen design inconsistent*
      *             (Recompile)                                       *
      *  BUG22515 - Increased length of Exemption Type Description    *
      *             field from 30 to 60 characters (Recompile)        *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *  ===========================================                  *
      *                                                               *
      *  15-16        Protect Screen fields                           *
      *  20-22        Error on Screen fields                          *
      *    30         Ind error generalTax field                      *
      *    40         Enquiry authorized                              *
      *    41         Amend authorized                                *
      *    42         Insert authorized                               *
      *    43         Delete auth and system set-up module is OFF     *
      *    45         Delete authorized                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *  ===============================                              *
      *                                                               *
      *  SRMain - Initial routine                                     *
      *  SRTrait - Enter press on the first screen                    *
      *  SRScr2 - Display screen 2                                    *
      *  SRVact - Validate action code                                *
      *  SRSetup - Setup field and attribute                          *
      *  SRVal - Validate field screen 2                              *
      *  SRUfile - Setup file                                         *
      *  SRRlup - Roll up                                             *
      *  SRDspl - Display subfile                                     *
      *  SRInsfl - Initialize subfile                                 *
      *  SRLosfl - Load subfile                                       *
      *  SRZasnms - Send message to program'S message queue           *
      *  *INZSR - Program initialization routine                      *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialization only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
      *
     FSDECTYL0  UF A E           K DISK    INFSR(*PSSR)
      *
     FSD000816DFCF   E             WORKSTN
     F                                     SFILE(SD000816S1:RRN)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the
      **                            database error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Midas modules details
      *
     D SDMMOD        E DS                  Extname(SDMMODPD)
      *
      ** First DS for access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** EC type's validation
      *
     D   WCtCd         C                   'ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ0123456789'
      *
      ** Parameters for access object
      *
     D  PRtcd          S              7A
     D  POptn          S              7A
      *
      ** Parameters for Y2MS
      *
     D  PZaPgm         S             10A
     D  PZaPgrl        S              5A
     D  PZaMsid        S              7A
     D  PZaMsgf        S             10A
     D  PZaMsda        S            132A
     D  PZaMstp        S              7A
      *                                                                                     AR797240
      ** Parameters                                                                         AR797240
      *                                                                                     AR797240
     D PMode           S              1A                                                    AR797240
      *
      ** Work variables
      *
     D  WkN            S              2P 0
     D  WkWlin         S              2P 0
     D  WkWrrn         S              4P 0
     D  WkErr          S              1P 0
     D  WkX            S              1P 0
     D  WkWrevie       S              2A
     D  WkAction       S              1A
     D  WkWwvty        S              2A
     D  WkWwdbrn       S              3A
     D  WkZactn        S              1A
     D  WkZbr          S              3A
     D  WkPmsgf        S             10A
     D  WRun           S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Execute initial processing
      *
     C                   EXSR      SRMain
      *
     C                   DOW       *INKC = *OFF
      *
      ** Display Subfile
      *
     C                   EXSR      SRDspl
      *
     C                   IF        *INKC = *ON
     C                   LEAVE
     C                   ENDIF
      *
      ** Traitement Subfile
      *
     C                   EXSR      SRTrait
      *
      ** If review from changed
      *
     C                   IF        DREVIE <> WkWrevie
      *
     C                   MOVEL     DREVIE        WkWrevie
     C                   EXSR      SRInsfl
     C                   EXSR      SRLosfl
      *
     C                   ELSE
      *
      ** Roll Up Processing
      *
     C                   IF        *IN83 = *ON
      *
     C                   EXSR      SRRlup
     C                   EXSR      SRLosfl
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTrait - Enter press on the first screen                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRVact , SRScr2                                       *
      *                                                               *
      *****************************************************************
     C     SRTrait       BEGSR
      *
      ** Setof general error indicator
      *
     C                   EVAL      *IN22  = *OFF
     C                   EVAL      *IN30  = *OFF
     C                   EVAL      *IN31  = *OFF
      *
      ** Valid action code
      ** Check if option D, E, A
      *
     C                   IF        *IN81 = *OFF
      *
     C                   READC(E)  SD000816S1
      *
     C                   DOW       %EOF = *OFF
      *
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      WkAction = DDSEL
     C                   EXSR      SRVact
      *
      ** Update subfile
      *
     C     RRN           CHAIN(E)  SD000816S1
      *
     C                   IF        NOT %ERROR
      *
     C                   IF        DDSEL = *BLANKS
     C                   EVAL      *IN31 = *OFF
     C                   ELSE
      *
     C                   EVAL      *IN31 = *ON
     C                   ENDIF
      *
     C                   UPDATE    SD000816S1
      *
     C                   ENDIF
      *
     C                   READC(E)  SD000816S1
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Validation selection is ok
      *
     C                   IF        *IN30 = *OFF
      *
      ** F9 Add press
      *
     C                   IF        *INKI = *ON
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      WkAction = 'I'
     C                   EXSR      SRScr2
     C                   ENDIF
      *
      ** Traitment selection code
      *
     C                   IF        *IN81 = *OFF
     C                   READC(E)  SD000816S1
      *
     C                   DOW       %EOF  = *OFF AND
     C                             *INKC = *OFF AND
     C                             *INKL = *OFF AND
     C                             *IN30 = *OFF
     C                   EVAL      WkAction = DDSEL
     C                   EXSR      SRScr2
      *
      ** Update subfile
      *
     C     RRN           CHAIN(E)  SD000816S1
      *
     C                   IF        NOT %ERROR
      *
     C                   IF        *IN30 = *OFF
     C                   EVAL      DDSEL = *BLANKS
     C                   EVAL      *IN31 = *OFF
     C                   ENDIF
      *
     C                   UPDATE    SD000816S1
      *
     C                   ENDIF
     C                   READC(E)  SD000816S1
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScr2 - Display screen 2                                    *
      *                                                               *
      *  Called by: SRTrait                                           *
      *                                                               *
      *  Calls: SRSetup , SRZasnms , SRVal , SRUfile                  *
      *                                                               *
      *****************************************************************
     C     SRScr2        BEGSR
      *
      ** Setup field and attribute
      *
     C                   EXSR      SRSetup
      *
      ** Until no errors
      *
     C                   DOU       *IN30 = *OFF
      *
      ** Write and read second screen
      *
     C                   WRITE     SD000816C0
     C                   EXFMT     SD000816F2
      *
      ** Initialise program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    PZaPgm
     C                   PARM      '*SAME'       PZaPgrl
      *
      ** Setup off error indicators
      *
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
      *
      ** Validate cmd key pressed
      ** F3 / F12 pressed or Enquiry mode
      *
     C                   IF        *INKC  = *ON OR
     C                             *INKL  = *ON OR
     C                             WkAction = 'E'
     C                   LEAVE
     C                   ENDIF
      *
      ** If Delete mode and F10 not pressed
      *
     C                   IF        WkAction = 'D'  AND
     C                             *INKJ  = *OFF
      *
     C                   EVAL      *IN30  = *ON
      *
      ** Send message 'Press F10 to delete'
      *
     C                   EVAL      PZaMsid = 'ASM0028'
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
      *
      ** Valid field screen 2
      *
     C                   EXSR      SRVal
      *
      ** If error redisplay screen 2
      *
     C                   IF        *IN30 = *ON
     C                   ITER
     C                   ENDIF
      *
      ** Update file
      *
     C                   EXSR      SRUfile
      *
     C                   ENDDO
      *
      ** Setup work field
      *
     C                   EVAL      WkWrevie = *HIVAL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVact - validate action code                                *
      *                                                               *
      *  Called by: SRTrait                                           *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
     C     SRVact        BEGSR
      *
     C                   IF        PMode = 'M'                                              AR797240
     C                   IF        DDSEL <> 'E' AND
     C                             DDSEL <> 'A' AND
     C                             DDSEL <> 'D' AND
     C                             DDSEL <> ' '
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'Action code no valid'
      *
     C                   EVAL      PZaMsid = 'SCC0013'
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
     C                   ELSE                                                               AR797240
     C                   IF        DDSEL <> 'E' AND                                         AR797240
     C                             DDSEL <> ' '                                             AR797240
      *                                                                                     AR797240
     C                   EVAL      *IN22 = *ON                                              AR797240
     C                   EVAL      *IN30 = *ON                                              AR797240
      *                                                                                     AR797240
      ** Send message 'Action code no valid'                                                AR797240
      *                                                                                     AR797240
     C                   EVAL      PZaMsid = 'SCC0051'                                      AR797240
     C                   EXSR      SRZasnms                                                 AR797240
      *                                                                                     AR797240
     C                   ENDIF                                                              AR797240
     C                   ENDIF                                                              AR797240
      *
     C                   IF        DDSEL = 'A'  AND *IN41 = *OFF
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'User not authorised to Amend'
      *
     C                   EVAL      PZaMsid = 'USR8239'
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
      *
     C                   IF        DDSEL = 'D'  AND
     C                             *IN43 = *OFF
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'User not authorised to Delete'
      *
     C                   EVAL      PZaMsid = 'USR8239'
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
      *
     C                   IF        DDSEL = 'E' AND
     C                             *IN40 = *OFF
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'User not authorised to Enquire'
      *
     C                   EVAL      PZaMsid = 'USR8239'
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetup- Setup field and attribute                           *
      *                                                               *
      *  Called by: SRTrait                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRSetup       BEGSR
      *
     C                   EVAL       D2TYPE = *BLANKS
     C                   EVAL       D2TDES = *BLANKS
      *
     C                   SELECT
      *
     C                   WHEN      WkAction = 'I'
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN15 = *OFF
     C                   EVAL      *IN16 = *OFF
      *
     C                   WHEN      WkAction = 'E'
     C                   EVAL      D2TYPE = D1TYPE
     C                   EVAL      D2TDES = D1TDES
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN15 = *ON
     C                   EVAL      *IN16 = *ON
      *
     C                   WHEN      WkAction = 'A'
     C                   EVAL      D2TYPE = D1TYPE
     C                   EVAL      D2TDES = D1TDES
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN15 = *ON
     C                   EVAL      *IN16 = *OFF
      *
     C                   WHEN      WkAction = 'D'
     C                   EVAL      D2TYPE = D1TYPE
     C                   EVAL      D2TDES = D1TDES
     C                   EVAL      *IN45 = *ON
     C                   EVAL      *IN15 = *ON
     C                   EVAL      *IN16 = *ON
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal  - Validate field screen 2                             *
      *                                                               *
      *  Called by: SRTrait                                           *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
     C     SRVal         BEGSR
      *
      ** Validate EC Type
      *
     C                   IF        WkAction = 'I'
      *
     C     WCtCd         CHECK     D2TYPE        WkN
      *
     C                   IF        %FOUND    OR
     C                             D2TYPE = *BLANKS
      *
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'EC Type: must be a valid
      ** two-character alphanumeric code'
      *
     C                   EVAL      PZaMsid = 'USR8237'
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
      *
      ** If record exist
      *
     C     D2TYPE        CHAIN     SDECTYL0
      *
     C                   IF        %Found(SDECTYL0)
      *
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZaMsid = 'USR0017'
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        WkAction = 'I'  OR
     C                             WkAction = 'A'
      *
      ** Validate EC Description
      *
     C                   IF        D2TDES = *BLANKS
      *
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'EC Description: Free format,
      ** must not be left blank'
      *
     C                   EVAL      PZaMsid = 'USR8238'
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUfile- Setup file                                          *
      *                                                               *
      *  Called by: SRTrait                                           *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
     C     SRUfile       BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      WkAction = 'I'
      *
      ** check if the record has not been created by another user
      *
     C     D2TYPE        CHAIN     SDECTYL0
      *
     C                   IF        %FOUND(SDECTYL0)
      *
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'EC Type has been Created by another user'
      *
     C                   EVAL      PZaMsid = 'USR8241'
     C                   EXSR      SRZasnms
      *
     C                   ELSE
      *
      ** Write record
      *
     C                   EVAL      TCTYPE = D2TYPE
     C                   EVAL      TCTDES = D2TDES
     C                   EVAL      TCCHTP  = 'I'
     C                   EVAL      TCLCD   = BJRDNB
     C                   WRITE     SDECTYD0
      *
     C                   ENDIF
      *
     C                   WHEN      WkAction = 'A'
      *
      ** Check if record exist
      *
     C     D2TYPE        CHAIN     SDECTYL0
      *
     C                   IF        NOT %FOUND(SDECTYL0)
      *
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'EC Description has been
      ** deleted by another user'
      *
     C                   EVAL      PZaMsid = 'USR8242'
     C                   EXSR      SRZasnms
      *
     C                   ELSE
      *
      ** Check if the EC description has not been
      ** modified by another user
      *
     C                   IF        D1TDES <> TCTDES
      *
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'EC Description has been
      ** modified by another user'
      *
     C                   EVAL      PZaMsid = 'USR8240'
     C                   EXSR      SRZasnms
      *
     C                   ELSE
      *
      ** Update record
      *
     C                   EVAL      TCTDES = D2TDES
      *
     C                   IF        BJRDNB <> TCLCD
     C                   EVAL      TCCHTP = 'A'
     C                   ELSE
     C                   EVAL      TCCHTP = 'I'
     C                   ENDIF
      *
     C                   EVAL      TCLCD = BJRDNB
     C                   UPDATE    SDECTYD0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   WHEN      WkAction = 'D'
      *
      ** Check if record exist
      *
     C     D2TYPE        CHAIN     SDECTYL0
      *
     C                   IF        NOT %FOUND(SDECTYL0)
      *
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'EC Description has been
      ** deleted by another user'
      *
     C                   EVAL      PZaMsid = 'USR8242'
     C                   EXSR      SRZasnms
      *
     C                   ELSE
      *
      ** Check if the EC description has not been
      ** modified by another user
      *
     C                   IF        D1TDES <> TCTDES
      *
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN30 = *ON
      *
      ** Send message 'EC Description has been
      ** modified by another user'
      *
     C                   EVAL      PZaMsid = 'USR8240'
     C                   EXSR      SRZasnms
      *
     C                   ELSE
      *
      ** Delete record
      *
     C                   DELETE    SDECTYL0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRlup - Roll up processing                                  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRlup        BEGSR
      *
     C                   Z-ADD     WkWrrn        RRN
      *
     C     WkWwvty       SETLL     SDECTYL0
     C                   READ(N)   SDECTYL0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspl - Display subfile                                     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
     C     SRDspl        BEGSR
      *
      ** No data to display
      *
     C                   IF        RRN = 0
      *
     C                   EVAL      *IN81 = *ON
      *
      ** Send message 'No data to display'
      *
     C                   EVAL      PZaMsid = 'ASM0001'
     C                   EXSR      SRZasnms
      *
     C                   ELSE
      *
     C                   EVAL      *IN81 = *OFF
      *
     C                   ENDIF
      *
      ** Display SFL
      *
     C                   WRITE     SD000816C0
     C                   WRITE     SD000816F1
     C                   EXFMT     SD000816C1
      *
      ** Initialise program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    PZaPgm
     C                   PARM      '*SAME'       PZaPgrl
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsfl- Initialize subfile                                  *
      *                                                               *
      *  Called by: Main Processing , SRMain                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRInsfl       BEGSR
      *
      ** Clear SFL
      *
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000816C1
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *ON
     C                   EVAL      RRN   = 0
      *
      ** If nothing selected, position subfile at the beginning
      *
     C                   IF        DREVIE  = *BLANKS
      *
     C     *LOVAL        SETLL     SDECTYL0
     C                   READ(N)   SDECTYL0
      *
     C                   ELSE
      *
     C     DREVIE        SETLL     SDECTYL0
     C                   READ(N)   SDECTYL0
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLosfl- Load subfile                                        *
      *                                                               *
      *  Called by: Main Processing , SRMain                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRLosfl       BEGSR
      *
      ** Initiate screen line number
      *
     C                   EVAL      WkWlin = 0
     C                   EVAL      *IN22 = *OFF
      *
      ** Load subfile
      *
     C                   DOW       NOT %EOF(SDECTYL0) AND WkWlin < 13
      *
     C                   CLEAR                   SD000816S1
     C                   EVAL      D1TYPE  = TCTYPE
     C                   EVAL      D1TDES  = TCTDES
      *
      ** Write record into SFL
      *
     C                   EVAL      *IN81  = *OFF
     C                   EVAL      RRN    = RRN + 1
     C                   EVAL      WkWlin = WkWlin + 1
     C                   WRITE     SD000816S1
      *
      ** Read next record
      *
     C                   READ(N)   SDECTYL0
     C                   ENDDO
      *
      ** Save RRN
      *
     C                   EVAL      WkWrrn = RRN
      *
      ** Save file position
      *
     C                   IF        NOT %EOF(SDECTYL0)
      *
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WkWwvty = TCTYPE
      *
     C                   ELSE
      *
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      WkWwvty = *HIVAL
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRmain - Initial routine                                     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRInsfl , SRLosfl                                 *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
      ** Check the default branch for the user
      *
     C     PSUser        CHAIN     MUSER
     C                   IF        %FOUND(MUSER)
     C                   EVAL      WkWwdbrn = DBRN
     C                   ELSE
     C                   EVAL      WkWwdbrn = *BLANKS
     C                   ENDIF
      *
      ** Check user authorised to action code
      *
     C                   EVAL      WkX = 1
     C                   DOW       WkX <= 4
      *
     C                   IF        WkX = 1
     C                   EVAL      WkZactn = 'A'
     C                   ENDIF
      *
     C                   IF        WkX = 2
     C                   EVAL      WkZactn = 'E'
     C                   ENDIF
      *
     C                   IF        WkX = 3
     C                   EVAL      WkZactn  = 'I'
     C                   ENDIF
      *
     C                   IF        WkX = 4
     C                   EVAL      WkZactn = 'D'
     C                   ENDIF
      *
      ** If multibranched
      *
     C                   IF        BGMBIN  = 'Y'
     C                   CALL      'ZVACTBU'
     C                   PARM                    WkZactn
     C                   PARM      WkWwdbrn      WkZbr
     C                   PARM      *ZEROS        WkErr
     C                   ELSE
     C                   CALL      'ZVACTU'
     C                   PARM                    WkZactn
     C                   PARM      *ZEROS        WkErr
     C                   ENDIF
      *
     C                   IF        WkErr = 0
      *
     C                   IF        WkZactn = 'E'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
     C                   IF        WkZactn = 'A'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
      *
     C                   IF        WkZactn = 'I'
     C                   EVAL      *IN42 = *ON
     C                   ENDIF
      *
     C                   IF        WkZactn = 'D' AND  BJSUC <> 'Y'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
     C                   END
      *
     C                   EVAL      WkX = WkX + 1
     C                   ENDDO
      *
      ** Load first screen
      *
     C                   EXSR      SRInsfl
     C                   EXSR      SRLosfl
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZasnms - Send message to program'S message queue           *
      *                                                               *
      *  Called by: SRTrait, SRVact, SRVal, SRUfile , SRDspl          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZasnms      BEGSR
      *
      ** If no message file specified, use the default message file
      *
     C                   IF        PZaMsgf = *BLANKS
     C                   EVAL      PZaMsgf = WkPmsgf
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZaPgm
     C                   PARM                    PZaPgrl
     C                   PARM                    PZaMsid
     C                   PARM                    PZaMsgf
     C                   PARM                    PZaMsda
     C                   PARM                    PZaMstp
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   EVAL      PZaPgm  = PSProcName
     C                   EVAL      PZaPgrl = *BLANKS
     C                   EVAL      PZaMsda = *BLANKS
     C                   EVAL      PZaMstp = *BLANKS
     C                   EVAL      PZaMsgf = *BLANKS
     C                   EVAL      PZaMsid = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *                                                                                     AR797240
      ** Entry parameters                                                                   AR797240
      *                                                                                     AR797240
     C     *ENTRY        PLIST                                                              AR797240
     C                   PARM                    PMode                                      AR797240
      *
      ** Select the program MSGQ for error msg.
      *
     C                   EVAL      WkPmsgf = 'SDUSRMSG'
     C                   EVAL      SPGMQ = PSProcName
     C                   EVAL      DDPGM = PSProcName
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJObName
     C                   EVAL      DBPGM = PSProcName
      *
      ** Fill in fields for subroutine SRZasnms
      *
     C                   EVAL      PZaPgm  =  PSProcName
     C                   EVAL      PZaMsgf =  *BLANKS
     C                   EVAL      PZaPgrl =  *BLANKS
     C                   EVAL      PZaMsid =  *BLANKS
     C                   EVAL      PZaMsda =  *BLANKS
     C                   EVAL      PZaMstp =  *BLANKS
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Check if multibranched
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     AR797240
      ** Display the screen according to Mode ('M' Maintenance 'E' Enquiry)                 AR797240
      *                                                                                     AR797240
     C                   IF        PMode = 'E'                                              AR797240
     C                   EVAL      *In90 = *On                                              AR797240
     C                   ENDIF                                                              AR797240
      *                                                                                     AR797240
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
