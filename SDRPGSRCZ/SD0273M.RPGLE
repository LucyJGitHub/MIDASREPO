     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022' )
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Facility Type Class Maintenance')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0273M - Midas SD Facility Type Class Maintenance           *
      *                                                               *
      *  Function:  This sub-file program allows the user to          *
      *             maintain facility types classes                   *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060330           Date 09Aug22               *
      *  Prev Amend No. MD060092*CREATE    Date 01Aug22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060330 - Duplicate class code is defined on same facility  *
      *             type when selected via '?' option                 *
      *           - transfer the validation of class code after       *
      *             AOTCLSR0                                          *
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

     FSD0273M#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:@@RRN)

      ** Table of field numbers and names
     FSDFACTY0  IF   E           K DISK    INFSR(*PSSR)

      ** Table of field numbers and names
     FSDFACTY1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFACTF0:SDFACTFU)

      ** Facilities File by FACT and FCLS
     FLEFCLTLX  IF   E           K DISK    INFSR(*PSSR)

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

     D CLSARR          S              4    DIM(12)
     D CDSARR          S             30    DIM(12)
      ** Class entry array

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D SFMODE          S              3    INZ('CHG')
     D DELOK           S              1    INZ('Y')
     D INSOK           S              1    INZ('N')
     D #ERROR          S              1    INZ('N')
     D @BDSFL          S              1    INZ('N')
     D @@RMAX          S              5  0 INZ(0)
     D @@CNT           S              5  0 INZ(0)
     D @@PAGE          S              5  0 INZ(0)
     D @@RRN           S              5  0 INZ(0)
     D C               S              3  0 INZ(0)
     D X               S              3  0 INZ(0)
     D Y               S              3  0 INZ(0)


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
      *
     C                   EXSR      INIT
      *
      ** Main processing
      *
     C                   EXSR      MAIN
      *
      ** Return
      *
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
      *
      ** Display screen
      *
     C                   EXSR      DSPSCN
      *
      ** PROCESS RESPONSE:
      *
     C                   SELECT
     C                   WHEN      *INKC = *ON
     C                   WHEN      *INKL = *ON
     C                   WHEN      *INKE = *ON
      *
      **  F5: Reload subfile
      *
     C                   EXSR      RELOD
      *
     C                   WHEN      *INKI = *ON
      *
      **  F9: Switch to ADD/CHG mode
      *
     C                   EXSR      SWMODE
      *
     C                   WHEN      *IN27 = *ON AND
     C                             @BDSFL = 'Y'
      *
      **  Rollup
      *
     C                   EXSR      BLDSFL
      *
     C                   OTHER
      *
      **  Validate
      *
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
      *
     C                   IF        SFMODE = 'ADD' OR
     C                             @BDSFL = 'N'
     C                   EVAL      *IN89 = *ON
     C                   EVAL      *IN91 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     #SFLCTL
      *
      **  Read the subfile control record
      *
     C                   READ      #SFLCTL                                99
      *
      ** Clear program message queue
      *
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
      *
     C                   EVAL      *IN80 = *ON
     C                   WRITE     #SFLCTL
     C                   EVAL      *IN80 = *OFF
      *
      ** Reset Subfile cursor
      *
     C                   EVAL      #HSFRC = 1
      *
      ** Maximum record
      *
     C                   EVAL      @@RMAX = 0
      *
     C                   IF        SFMODE = 'CHG'
      *
      ** Set file pointer to start of file
      *
     C     W0FCTY        SETLL     SDFACTY0                               91
      *
     C                   IF        *IN91 = *ON
      *
      ** Facility type class exist
      *
     C                   EVAL      @BDSFL = 'Y'
     C                   EXSR      BLDSFL
     c                   ELSE
     C                   EVAL      @BDSFL = 'N'
      *
      ** Error: No record found
      *
     C                   CALL      'ZA0340'
     C                   PARM      'Y2USRMSG'    ZAMSGF           10
     C                   PARM      'Y2U0008'     ZAMSID           10
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Add mode
      *
     C                   IF        SFMODE = 'ADD'
     C                   EVAL      @BDSFL = 'Y'
     C                   EXSR      BLDSFL
     c                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * SWMODE - Switch Add/Change mode
      ********************************************************************
     C     SWMODE        BEGSR
      *
      ** Set update/add mode footer
      *
     C                   IF        SFMODE = 'ADD'
     C                   EVAL      SFMODE = 'CHG'
      *
      ** D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode   F12=Previous
      *
     C                   EVAL      MSGDNB = 'CLE1389'
     C                   ELSE
     C                   EVAL      SFMODE = 'ADD'
      *
      ** F3=Main Menu   F5=Refresh   F9=Go to 'Change' Mode   F12=Previous
      *
     C                   EVAL      MSGDNB = 'CLE1390'
     C                   ENDIF
      *
     C                   EVAL      MSGNM  = 'SDUSRMSG'
     C                   EXSR      RTVTXT
     C                   EVAL      #FOTXT = MSGTXT
      *
      ** Reload subfile
      *
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
     C                   IF        SFMODE = 'CHG'
     C     #SCLAS        Ifne      *Blanks
      *
      ** Set file pointer
      *
     C                   EVAL      K1FCTY = W0FCTY
     C                   EVAL      K1CLAS = #SCLAS
      *
     C     @KCLAS        SETLL     SDFACTY0
     C                   READ      SDFACTY0                               91
     C                   ELSE
     C                   IF        *IN91 = *OFF
     C     W0FCTY        READPE    SDFACTY0                               91
     C                   IF        *IN91 = *ON
     C     W0FCTY        SETLL     SDFACTY0
     C                   ENDIF
     C                   ENDIF
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      *
     C     W0FCTY        READE     SDFACTY0                               91
     C                   Endif
     C                   ENDIF
      *
      **  Initialise count of records written to subfile page.
      *
     C                   EVAL      @@RRN = @@RMAX
     C                   EVAL      @@CNT = 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C                   DOW       (*IN91 = *OFF AND
     C                             SFMODE = 'CHG'
     C                             AND AMFCTY = W0FCTY OR
     C                             SFMODE = 'ADD') AND
     C                             @@CNT < @@PAGE
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   EVAL      @@RRN = @@RRN + 1
     C                   EVAL      @@CNT = @@CNT + 1
      *
      **  Reset display indicators
      *
     C                   EVAL      #1SEL = *BLANK
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
      *
      **  Write Facility Type Class to subfile
      *
     C                   IF        SFMODE = 'ADD'
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      #1CLAS = *BLANKS
     C                   EVAL      #1CDSC = *BLANKS
     C                   ELSE
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      *IN88 = *ON
     C                   EVAL      #1CLAS = AMCLAS
      *
     C                   CALL      'AOTCLSR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      #1CLAS        @CLAS             4
     C     SDTCLS        PARM      SDTCLS        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      TCCDSC        #1CDSC
     C                   MOVE      @CLAS         #1CLAS
     C                   ELSE
     C                   MOVE      *BLANKS       #1CDSC
     C                   Endif
      *
     C                   ENDIF
     C                   WRITE     #SFLRCD
      *
      **  Read next Facility Type Class
      *
     C                   IF        SFMODE = 'CHG'
     C     W0FCTY        READE     SDFACTY0                               91
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Reset subfile cursor pointer
      *
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
     C                   EVAL      DELOK = 'Y'
     C                   EVAL      INSOK = 'N'
      *
      **  validate for edit mode
      *
     C                   IF        SFMODE = 'CHG'
     C                   EXSR      VALIDATECHG
     C                   IF        DELOK = 'Y'
     C                   EXSR      RELOD
     C                   ENDIF
     C                   ELSE
      *
      **  validate for insert mode
      *
     C                   EXSR      VALIDATEADD
     C                   IF        INSOK = 'Y'
     C                   EXSR      SWMODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      * VALIDATECHG - Validate screen input/EDIT screen
      ********************************************************************
     C     VALIDATECHG   BEGSR
      *
      **  Check first if Search criteria entered
      *
     C                   IF        #SCLAS <> *BLANKS
     C                   EXSR      BLDSFL
     C                   ELSE
      *
      **  Or, Read and validate each Class record
      *
     C                   DOU       *IN99 = *ON
      *
     C                   READC     #SFLRCD                                99
      *
     C                   IF        *IN99 = *OFF
      *
      ** CHG Mode: If 'D' is input, Delete
      *
     C                   IF        #1SEL = 'D'
     C                   EXSR      DELETESR
     C                   ENDIF
      *
      **  If ERROR found
      *
     C                   IF        #ERROR = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   ELSE
      *
      **  NO ERROR: Reset display indicators
      *
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      #1SEL = *BLANK
     C                   ENDIF
      *
      **  Update subfile record/fld display attributes
      *
     C                   UPDATE    #SFLRCD
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      * VALIDATEADD - Validate screen input/ADD screen
      ********************************************************************
     C     VALIDATEADD   BEGSR
      *
     C                   EVAL      C = 1
     C                   EVAL      X = 1
     C                   EVAL      Y = 0
      *
      **  Copy subfile data to array
      *
     C                   DOU       C > 12 OR *IN99 = *ON
      *
     C     C             CHAIN     #SFLRCD                            99
     C                   IF        *IN99 = *OFF
     C                   EVAL      CLSARR(C) = #1CLAS
     C                   EVAL      CDSARR(C) = #1CDSC
     C                   EVAL      C = C + 1
     C                   EVAL      *IN33 = *OFF
     C                   UPDATE    #SFLRCD
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   IF        #ERROR <> 'Y'
      *
      **  Check if a Valid class
      *
     C                   EVAL      C = 1
      *
     C                   DOW       C < 13
      *
      **  Reset display indicators
      *
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
      *
     C                   IF        CLSARR(C) <> *BLANKS
      *
     C**********         EVAL      K1FCTY = W0FCTY                                          MD060330
     C**********         EVAL      K1CLAS = CLSARR(C)                                       MD060330
      **********                                                                            MD060330
     C*****@KCLASF       CHAIN     SDFACTY1      F                    92                    MD060330
     C**********         IF        *IN92 = *OFF                                             MD060330
     C**********         EVAL      #ERROR = 'Y'                                             MD060330
     C**********         EVAL      *IN33 = *ON                                              MD060330
      ***Error:*Class already exists                                                        MD060330
     C**********         CALL      'ZA0340'                                                 MD060330
     C**********         PARM      'SDUSRMSG'    ZAMSGF                                     MD060330
     C**********         PARM      'CLE1386'     ZAMSID                                     MD060330
     C**********         ENDIF                                                              MD060330
      *
     C                   CALL      'AOTCLSR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CLSARR(C)     @CLAS             4
     C     SDTCLS        PARM      SDTCLS        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      TCCDSC        #1CDSC
     C                   MOVE      TCCDSC        CDSARR(C)
     C                   MOVE      @CLAS         #1CLAS
     C                   MOVE      @CLAS         CLSARR(C)
     C                   ELSE
     C                   MOVE      *BLANKS       #1CDSC
     C                   MOVE      *BLANKS       CDSARR(C)
     C                   EVAL      #ERROR = 'Y'
     C                   EVAL      *IN33 = *ON
      *
      ** Error: Invalid Class
      *
     C                   CALL      'ZA0340'
     C                   PARM      'SDUSRMSG'    ZAMSGF
     C                   PARM      'CLE1392'     ZAMSID
     C                   Endif
      *
     C                   EVAL      K1FCTY = W0FCTY                                          MD060330
     C                   EVAL      K1CLAS = CLSARR(C)                                       MD060330
      *                                                                                     MD060330
     C     @KCLASF       CHAIN     SDFACTY1                           92                    MD060330
     C                   IF        *IN92 = *OFF                                             MD060330
     C                   EVAL      #ERROR = 'Y'                                             MD060330
     C                   EVAL      *IN33 = *ON                                              MD060330
      ** Error: Class already exists                                                        MD060330
     C                   CALL      'ZA0340'                                                 MD060330
     C                   PARM      'SDUSRMSG'    ZAMSGF                                     MD060330
     C                   PARM      'CLE1386'     ZAMSID                                     MD060330
     C                   ENDIF                                                              MD060330
     C                   ENDIF
      *
     C     C             CHAIN     #SFLRCD                            99
     C                   IF        *IN99 = *OFF
      *
      **  Update subfile record/fld display attributes
      *
     C                   EVAL      #1CLAS = CLSARR(C)                                       MD060330
     C                   EVAL      #1CDSC = CDSARR(C)
     C                   UPDATE    #SFLRCD
     C                   ENDIF
      *
     C                   EVAL      C = C + 1
      *
     C                   ENDDO
     C                   ENDIF
      *
      **  Check for duplicate entry
      *
     C                   DOW       X < 12 AND #ERROR <> 'Y'
     C                   IF        CLSARR(X) <> *BLANKS
     C                   EVAL      Y = %LOOKUP(CLSARR(X) : CLSARR : x + 1)
     C                   IF        Y > 0 AND Y <> X
      *
      ** Issue Error: Duplicate Facility Class entered
      *
     C                   CALL      'ZA0340'
     C                   PARM      'SDUSRMSG'    ZAMSGF           10
     C                   PARM      'CLE1391'     ZAMSID           10
      *
     C                   EVAL      #ERROR = 'Y'
     C                   EVAL      *IN33 = *ON
      *
     C     X             CHAIN     #SFLRCD                            99
     C                   IF        *IN99 = *OFF
     C                   UPDATE    #SFLRCD
     C                   ENDIF
      *
     C     Y             CHAIN     #SFLRCD                            99
     C                   IF        *IN99 = *OFF
     C                   UPDATE    #SFLRCD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
      *
     C                   IF        #ERROR <> 'Y'
      *
      **  If Still NO ERROR found, then write Class to file
      *
     C                   EVAL      C = 1
      *
     C                   DOW       C <= 12
     C                   IF        CLSARR(C) <> *BLANKS
      *
     C                   EVAL      INSOK = 'Y'
     C                   EVAL      AMFCTY = W0FCTY
     C                   EVAL      AMCLAS = CLSARR(C)
     C                   WRITE     SDFACTFU
      *
     C                   ENDIF
     C                   EVAL      C = C + 1
     C                   ENDDO
     C                   ENDIF
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
      *
     C                   EVAL      #HSFRC = 1
     C                   EVAL      @@RMAX = 0
      *
      ** Set file pointer
      *
     C                   EVAL      K1FCTY = W0FCTY
     C                   EVAL      K1CLAS = #SCLAS
      *
     C     @KCLAS        SETLL     SDFACTY0
     C     W0FCTY        READE     SDFACTY0                               91
      *
     C                   IF        *IN91 = *ON
     C     @KCLAS        SETLL     SDFACTY0
     C     W0FCTY        READPE    SDFACTY0                               91
     C                   ENDIF
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
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
      * DELETESR - Delete class
      *****************************************************************
     C     DELETESR      BEGSR
      *
      ** Set file pointer
      *
     C                   EVAL      K1FCTY = W0FCTY
     C                   EVAL      K1CLAS = #1CLAS
     C                   EVAL      K2FCTY = W0FCTY
      *
      ** Check if Combination of Facility/type and class is in use by a Facility
      *
     C     @KFCLS        CHAIN     LEFCLTLX                           92
     C     *IN92         IFEQ      *OFF
     C                   EVAL      #ERROR = 'Y'
     C                   EVAL      DELOK = 'N'
      *
      ** If Class is in use, issue Error: Class cannot be deleted
      *
     C                   CALL      'ZA0340'
     C                   PARM      'SDUSRMSG'    ZAMSGF           10
     C                   PARM      'CLE1387'     ZAMSID           10
     C                   ELSE
      *
      ** NO Error: Delete Class
      *
     C     @KCLASF       CHAIN     SDFACTY1                           93
     C                   IF        *IN93 = *OFF
     C                   EVAL      #ERROR = 'N'
     C                   DELETE    SDFACTFU
     C                   ENDIF
     C                   ENDIF
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
      *
     C                   EVAL      #HMRDT = BJMRDT
      *
      ** Set initial footer
      ** D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode   F12=Previous
      *
     C                   EVAL      MSGDNB = 'CLE1389'
     C                   EVAL      MSGNM  = 'SDUSRMSG'
     C                   EXSR      RTVTXT
     C                   EVAL      #FOTXT = MSGTXT
      *
      ** Lookup Facility Type
      *
     C                   EVAL      #HFCTY = W0FCTY
      *
      ** Subfile page size
      *
     C                   EVAL      @@PAGE = 12
      *
      ** Initialise subfile relative record number.
      *
     C                   EVAL      @@RRN = 1
      *
      ** Load initial subfile
      *
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
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Input parameters
      *
      ** Facility type
      *
     C                   PARM                    W0FCTY            3
      *
      ** Return code
      *
     C                   PARM                    W0RTN             7
      *
      ** Initialise program name
      *
     C                   EVAL      #HPGM = 'SD0273M'
      *
      ** Move workstation ID to screen field.
      *
     C                   EVAL      #HUSR = PsUser
     C                   EVAL      #HJOB = PsJobName
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Keylist for class
      *
     C     @KCLAS        KLIST
     C                   KFLD                    K1FCTY            3
     C                   KFLD                    K1CLAS            4
      *
     C     @KCLASF       KLIST
     C                   KFLD                    K1CLAS
     C                   KFLD                    K1FCTY
      *
      ** Keylist for class
      *
     C     @KFCLS        KLIST
     C                   KFLD                    K2FCTY            3
     C                   KFLD                    K1CLAS
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
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
