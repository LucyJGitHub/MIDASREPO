     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Facility Type Class Enquiry')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0273E - Midas SD Facility Type Class Enquiry               *
      *                                                               *
      *  Function:  This sub-file program allows the user to          *
      *             maintain facility types classes                   *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD033528           Date 01Aug22               *
      *  Prev Amend No. MD060092*CREATE    Date 01Aug22               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD033528 - Does not show entries after page-down. Ensure     *
      *             file program will read again after pressing PgDwn *
      *  MD060092 - Revert CLE138 changes in SDFACTPD, AOFACTR0 and   *
      *             SD Facility Type Maintenance.                     *
      *           - Apply CLE138 original design of SDFACTX0 to store *
      *             facility classes.                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSD0273E#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:@@RRN)

      ** Table of field numbers and names
     FSDFACTY0  IF   E           K DISK    INFSR(*PSSR)

      ** Table of field numbers and names
     FSDFACTY1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFACTF0:SDFACTFU)

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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details

     D SDTCLS        E DS                  EXTNAME(SDTCLSPD)
      ** External DS for Classes

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D SFMODE          S              3    INZ('ENQ')
     D DELOK           S              1    INZ('N')
     D INSOK           S              1    INZ('N')
     D #ERROR          S              1    INZ('N')
     D @BDSFL          S              1    INZ('N')
     D @@RMAX          S              5  0 INZ(0)
     D @@CNT           S              5  0 INZ(0)
     D @@PAGE          S              5  0 INZ(0)
     D @@RRN           S              5  0 INZ(0)


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
      *
      ** Initialisation
     C                   EXSR      INIT
      *
      ** Main processing
     C                   EXSR      MAIN
      *
      ** Return
     C                   IF        *INKC = *ON
     C                   EVAL      W0RTN = 'Y2U9999'
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      * MAIN - Main processing
      ********************************************************************
     C     MAIN          BEGSR
      *
     C                   DOU       *INKC = *ON OR *INKL = *ON
      ** Display screen
     C                   EXSR      DSPSCN
      *
      ** PROCESS RESPONSE:
      *
     C                   SELECT
     C                   WHEN      *INKC = *ON
     C                   WHEN      *INKL = *ON
     C                   WHEN      *INKE = *ON
      **  F5: Reload subfile
     C                   EXSR      RELOD
      *
     C                   WHEN      *IN27 = *ON AND
     C                             @BDSFL = 'Y'
      **  Rollup
     C                   EXSR      BLDSFL
      *
     C                   OTHER
      **  Validate
     C                   IF        @BDSFL = 'Y'
     C                   EVAL      *IN84 = *ON
     C                   EXSR      VALIDATE
     C                   EVAL      *IN84 = *OFF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * DSPSCN - Display Subfile
      ********************************************************************
     C     DSPSCN        BEGSR
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #FOOTER
      *
     C                   IF        @BDSFL = 'Y' AND
     C                             @@CNT > 0
     C                   EVAL      *IN81 = *ON
     C                   ELSE
     C                   EVAL      *IN81 = *OFF
     C                   ENDIF
      *
      ** Set display mode indicators
     C                   EVAL      *IN89 = *OFF
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
     C                   WRITE     #SFLCTL
      *
      **  Read the subfile control record
     C                   READ      #SFLCTL                                99
      *
      ** Clear program message queue
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RELOD - Reload/initialize subfile
      ********************************************************************
     C     RELOD         BEGSR
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
     C                   EVAL      *IN80 = *ON
     C                   WRITE     #SFLCTL
     C                   EVAL      *IN80 = *OFF
      ** Reset Subfile cursor
     C                   EVAL      #HSFRC = 1
      ** Maximum record
     C                   EVAL      @@RMAX = 0
      *
     C                   IF        SFMODE = 'ENQ'
      ** Set file pointer to start of file
     C     W0FCTY        SETLL     SDFACTY0                               91
      *
     C                   IF        *IN91 = *ON
      ** Facility type class exist
     C                   EVAL      @BDSFL = 'Y'
     C                   EXSR      BLDSFL
     c                   ELSE
     C                   EVAL      @BDSFL = 'N'
      ** Error: No record found
     C                   CALL      'ZA0340'
     C                   PARM      'Y2USRMSG'    ZAMSGF           10
     C                   PARM      'Y2U0008'     ZAMSID           10
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * SWMODE - Switch Add/Change mode
      ********************************************************************
     C     SWMODE        BEGSR
      *
     C                   EVAL      MSGDNB = 'USR3346'
      *
     C                   EVAL      MSGNM  = 'SDUSRMSG'
     C                   EXSR      RTVTXT
     C                   EVAL      #FOTXT = MSGTXT
      *
      ** Reload subfile
     C                   EXSR      RELOD
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
     C                   IF        SFMODE = 'ENQ'
     C     #SCLAS        Ifne      *Blanks
      ** Set file pointer
     C                   EVAL      K1FCTY = W0FCTY
     C                   EVAL      K1CLAS = #SCLAS
      *
     C     @KCLAS        SETLL     SDFACTY0
     C                   READ      SDFACTY0                               91
     C                   Else
     C                   IF        *IN91 = *OFF                                             MD033528
     C     W0FCTY        READPE    SDFACTY0                               91                MD033528
     C                   IF        *IN91 = *ON                                              MD033528
     C     W0FCTY        SETLL     SDFACTY0                                                 MD033528
     C                   ENDIF                                                              MD033528
     C                   ENDIF                                                              MD033528
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
     C     W0FCTY        READE     SDFACTY0                               91
     C                   Endif
     C                   ENDIF
      *
      **  Initialise count of records written to subfile page.
     C                   EVAL      @@RRN = @@RMAX
     C                   EVAL      @@CNT = 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
     C                   DOW       (*IN91 = *OFF OR
     C                             SFMODE = 'ADD') AND
     C                             @@CNT < @@PAGE
     C                             AND AMFCTY = W0FCTY
      *
      **  Increment the subfile record no. and records written fields.
     C                   EVAL      @@RRN = @@RRN + 1
     C                   EVAL      @@CNT = @@CNT + 1
      *
      **  Reset display indicators
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
      *
      **  Write the invalid transaction to the subfile.
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      *IN88 = *ON
     C                   EVAL      #1CLAS = AMCLAS
      *
     C                   CALL      'AOTCLSR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      AMCLAS        @CLAS             4
     C     SDTCLS        PARM      SDTCLS        DSFDY
     C     @RTCD         Ifeq      *Blanks
     C                   Move      TCCDSC        #1CDSC
     C                   else
     C                   Move      *Blanks       #1CDSC
     C                   Endif
      *
     C                   WRITE     #SFLRCD
      *
      **  Read next Facility Type Class
     C                   IF        SFMODE = 'ENQ'
     C     W0FCTY        READE     SDFACTY0                               91
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Reset subfile cursor pointer
     C                   IF        @@RRN > @@RMAX
     C                   EVAL      #HSFRC = @@RMAX + 1
     C                   EVAL      @@RMAX = @@RRN
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * VALIDATE - Validate screen input
      ********************************************************************
     C     VALIDATE      BEGSR
      *
     C                   EVAL      #ERROR = 'N'
     C                   EVAL      DELOK = 'N'
     C                   EVAL      INSOK = 'N'
      *
      **  Check first if Search criteria entered
      *
     C                   IF        SFMODE = 'ENQ' AND #SCLAS <> *BLANKS
     C********           EXSR      SEARCHSR
     C                   EXSR      BLDSFL
     C                   ENDIF
      *
      ** Reload subfile
     C                   EXSR      RELOD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SEARCHSR - Search class
      *****************************************************************
     C     SEARCHSR      BEGSR
      *
      ** Reset fields
     C                   EVAL      #HSFRC = 1
     C                   EVAL      @@RMAX = 0
      ** Set file pointer
     C                   EVAL      K1FCTY = W0FCTY
     C                   EVAL      K1CLAS = #SCLAS
      *
     C     @KCLAS        SETLL     SDFACTY0
     C     W0FCTY        READE     SDFACTY0                               91
      *
     C                   IF        #SCLAS = AMCLAS
     C                   EVAL      #SCLAS = *BLANKS
     C                   ENDIF
      *
      ** Read back last record
     C     W0FCTY        READPE    SDFACTY0                               91
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
     C                   EVAL      *IN80 = *ON
     C                   WRITE     #SFLCTL
     C                   EVAL      *IN80 = *OFF
      *
     C                   EVAL      @BDSFL = 'Y'
     C                   EXSR      BLDSFL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTXT - RETRIEVE TEXT
      *****************************************************************
     C     RTVTXT        BEGSR
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM                    MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Set rundate
     C                   EVAL      #HMRDT = BJMRDT
      *
      ** Set initial footer
     C                   EVAL      MSGDNB = 'USR3346'
     C                   EVAL      MSGNM  = 'SDUSRMSG'
     C                   EXSR      RTVTXT
     C                   EVAL      #FOTXT = MSGTXT
      *
      ** Lookup Facility Type
     C                   EVAL      #HFCTY = W0FCTY
      ** Subfile page size
     C                   EVAL      @@PAGE = 12
      ** Initialise subfile relative record number.
     C                   EVAL      @@RRN = 1
      ** Load initial subfile
     C                   EXSR      RELOD
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * Input parameters
      *
      * Facility type
     C                   PARM                    W0FCTY            3
      * Return code
     C                   PARM                    W0RTN             7
      *
      ** Initialise program name
     C                   EVAL      #HPGM = 'SD0273E'
      *
      ** Move workstation ID to screen field.
     C                   EVAL      #HUSR = PsUser
     C                   EVAL      #HJOB = PsJobName
      *
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Keylist for class
     C     @KCLAS        KLIST
     C                   KFLD                    K1FCTY            3
     C                   KFLD                    K1CLAS            4

     C     @KCLASF       KLIST
     C                   KFLD                    K1CLAS
     C                   KFLD                    K1FCTY
      *
      * Keylist for class
     C     @KFCLS        KLIST
     C                   KFLD                    K2FCTY            3 0
     C                   KFLD                    K1CLAS            4

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
