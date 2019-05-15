     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*OVR *: OVRDBF FILE(SDFTNHLR) TOFILE(SDFTNHL0) SHARE(*NO)          : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Non-A/c Holder Browse')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDFTNHBRW - FATCA Non-accoount Holder Browse                 *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD039670           Date 26Jul16               *
      *                 MD029849           Date 12Sep14               *
      *                 MD026515           Date 28Apr14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039670 - FATCA Housekeeping program                        *
      *  MD029849 - Issues on NAHL/NAHE with FATCA                    *
      *  MD026515 - Deleted Record is still Visible in F14=List by US *
      *             Indicia                                           *
      *           - Applied fix MD025047                              *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDFTNHBDF CF   E             WORKSTN
     F                                     SFILE(SDFTNHS1:@@RRN)
      * Customer file - by Front Office Id.
     FSDFTNHL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @FTR            S             30    DIM(3) CTDATA PERRCD(1)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SystemDS        DS            12
     D  DDHMSV
     D  DDMCSV
     D  DDRPSV
     D  DDCISV
     D  DDCBSV
     D  DDCDSV
     D  DDGCSV
     D  DDIDSV
     D  DDJASV
     D  DDTESV
     D  DDTXSV
     D  DDAUSV
     D OverrideDS      DS            12
     D  DDHMOV
     D  DDMCOV
     D  DDRPOV
     D  DDCIOV
     D  DDCBOV
     D  DDCDOV
     D  DDGCOV
     D  DDIDOV
     D  DDJAOV
     D  DDTEOV
     D  DDTXOV
     D  DDAUOV
 
     D/COPY WNCPYSRC,SDCUSDBD01
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
      *
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Build Sub-file
      *
     C     @BDSFL        IFEQ      'Y'
      *
      **  If First time in or subfile by Midas trade number was previously
      **  being run, then build subfile keyed on Midas trade number.
      **  Stay in loop while F11 toggle key is used.
      *
     C     *INKN         DOUEQ     '0'
 
      *
      * Clear program message queue
     C                   CALL      'ZA0250'
      *
     C                   EXSR      BLDSFL
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Read Subfile Record
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
      *
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDSFL - BUILD SUBFILE
      *****************************************************************
     C     BLDSFL        BEGSR
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDFTNHS0
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C     *LOVAL        SETLL     SDFTNHL1
      *
      **  Read a Valid Customer
      *
     C                   EXSR      RDCUST
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
     C                   Z-ADD     0             @@CNT2            3 0                      MD029849
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C     FNLCTP        IFEQ      'D'                                                      MD039670
     C                   GOTO      RDCUST_TAG                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     15
     C/COPY WNCPYSRC,SDCUSDBC01
                                                                                            MD025047
      **  Load records with status not 'D'.                                                 MD025047
                                                                                            MD025047
     C                   IF        FNLCTP <> 'D'                                            MD025047
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
     C                   ADD       1             @@CNT2                                     MD029849
      *
      **  Write the customer to the subfile.
      *
      **  If action code or customer number selected is invalid
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      *BLANK        DDOPT2                                     MD029849
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDNAHL    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      *BLANK        DDOPT2                                     MD029849
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
 
     C                   EVAL      DDNAHO = FNNAHO
     C                   EVAL      DDHMSVD = FNHMSV
     C                   EVAL      DDHMOVD = FNHMOV
     C                   EVAL      DDMCSVD = FNMCSV
     C                   EVAL      DDMCOVD = FNMCOV
     C                   EVAL      DDRPSVD = FNRPSV
     C                   EVAL      DDRPOVD = FNRPOV
     C                   EVAL      DDCISVD = FNCISV
     C                   EVAL      DDCIOVD = FNCIOV
     C                   EVAL      DDCBSVD = FNCBSV
     C                   EVAL      DDCBOVD = FNCBOV
     C                   EVAL      DDCDSVD = FNCDSV
     C                   EVAL      DDCDOVD = FNCDOV
     C                   EVAL      DDGCSVD = FNGCSV
     C                   EVAL      DDGCOVD = FNGCOV
     C                   EVAL      DDIDSVD = FNIDSV
     C                   EVAL      DDIDOVD = FNIDOV
     C                   EVAL      DDJASVD = FNJASV
     C                   EVAL      DDJAOVD = FNJAOV
     C                   EVAL      DDTESVD = FNTESV
     C                   EVAL      DDTEOVD = FNTEOV
     C                   EVAL      DDTXSVD = FNTXSV
     C                   EVAL      DDTXOVD = FNTXOV
     C                   EVAL      DDAUSVD = FNAUSV
     C                   EVAL      DDAUOVD = FNAUOV
 
     C                   WRITE     SDFTNHS1
     C/COPY WNCPYSRC,SDCUSDBC02
                                                                                            MD025047
     C                   ENDIF                                                              MD025047
      *
      **  Read a valid Customer
      *
     C     RDCUST_TAG    TAG                                                                MD039670
     C                   EXSR      RDCUST
     C                   END
     C                   SETOFF                                       81                    MD029849
     C                   IF        @@EOF = 'Y' AND                                          MD029849
     C                             @@CNT2 < 16                                              MD029849
     C                   SETON                                        81                    MD029849
     C                   ENDIF                                                              MD029849
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     SDFTNHF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SDFTNHM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDFTNHS0
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     C                   MOVE      '1'           *IN93
     C                   WRITE     SDFTNHS1
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDFTNHS0
     c                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDFTNHS0
     c                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDFTNHS0                               99
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
 
      **  If F14, bypass further processing.
     C     *INKN         IFEQ      '1'
     C                   MOVEL     '1'           @INKN
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     DDOPT2        ORNE      *BLANK                                                   MD029849
     C                   READC     SDFTNHS1                               99
     C                   END
      *
      **  Return the selected customer reference and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
     C     PMODE         ANDNE     'E'                                                      MD029849
     C     *IN99         ORNE      '1'                                                      MD029849
     C     DDOPT2        ANDNE     *BLANK                                                   MD029849
     C     PMODE         ANDEQ     'E'                                                      MD029849
      *
     C                   IF        PMODE <> 'E'                                             MD029849
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE                                                               MD029849
     C                   MOVE      DDOPT2        @OPSEL                                     MD029849
     C                   ENDIF                                                              MD029849
     C                   MOVE      DDNAHO        @CUSEL
      *
     C                   ENDIF
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDCUST - READ A CUSTOMER
      *****************************************************************
     C     RDCUST        BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
     C                   MOVE      *BLANKS       USindicia        12
     C                   EVAL      %SUBST(USindicia:1:1) = DDHMTV
     C                   EVAL      %SUBST(USindicia:2:1) = DDMCTV
     C                   EVAL      %SUBST(USindicia:3:1) = DDRPTV
     C                   EVAL      %SUBST(USindicia:4:1) = DDCITV
     C                   EVAL      %SUBST(USindicia:5:1) = DDCBTV
     C                   EVAL      %SUBST(USindicia:6:1) = DDCDTV
     C                   EVAL      %SUBST(USindicia:7:1) = DDGCTV
     C                   EVAL      %SUBST(USindicia:8:1) = DDIDTV
     C                   EVAL      %SUBST(USindicia:9:1) = DDJATV
     C                   EVAL      %SUBST(USindicia:10:1) = DDTETV
     C                   EVAL      %SUBST(USindicia:11:1) = DDTXTV
     C                   EVAL      %SUBST(USindicia:12:1) = DDAUTV
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     FNNAHO        ORNE      *BLANKS
      *
     C                   READ      SDFTNHL1                               96
      **                                                                                    MD039670
     C                   IF        FNLCTP = 'D'                                             MD039670
     C                   LEAVE                                                              MD039670
     C                   ENDIF                                                              MD039670
      **
     C                   MOVE      *BLANK        IgnorRec         12
 
     C                   IF        DDHMSV <> *BLANK
     C                   IF        FNHMSV <> DDHMSV AND
     C                             DDHMSV <> 'B' OR
     C                             DDHMSV = 'B' AND
     C                             FNHMSV <> ' '
     C                   EVAL      %SUBST(IgnorRec:1:1) = 'Y'
     C                   ENDIF
     C                   IF        DDHMSV <> 'Y' AND
     C                             DDHMSV <> 'N' AND
     C                             DDHMSV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:1:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDHMOV <> *BLANK
     C                   IF        FNHMOV <> DDHMOV AND
     C                             DDHMOV <> 'B' OR
     C                             DDHMOV = 'B' AND
     C                             FNHMOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:1:1) = 'Y'
     C                   ENDIF
     C                   IF        DDHMOV <> 'Y' AND
     C                             DDHMOV <> 'N' AND
     C                             DDHMOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:1:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDMCSV <> *BLANK
     C                   IF        FNMCSV <> DDMCSV AND
     C                             DDMCSV <> 'B' OR
     C                             DDMCSV = 'B' AND
     C                             FNMCSV <> ' '
     C                   EVAL      %SUBST(IgnorRec:2:1) = 'Y'
     C                   ENDIF
     C                   IF        DDMCSV <> 'Y' AND
     C                             DDMCSV <> 'N' AND
     C                             DDMCSV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:2:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDMCOV <> *BLANK
     C                   IF        FNMCOV <> DDMCOV AND
     C                             DDMCOV <> 'B' OR
     C                             DDMCOV = 'B' AND
     C                             FNMCOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:2:1) = 'Y'
     C                   ENDIF
     C                   IF        DDMCOV <> 'Y' AND
     C                             DDMCOV <> 'N' AND
     C                             DDMCOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:2:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDRPSV <> *BLANK
     C                   IF        FNRPSV <> DDRPSV AND
     C                             DDRPSV <> 'B' OR
     C                             DDRPSV = 'B' AND
     C                             FNRPSV <> ' '
     C                   EVAL      %SUBST(IgnorRec:3:1) = 'Y'
     C                   ENDIF
     C                   IF        DDRPSV <> 'Y' AND
     C                             DDRPSV <> 'N' AND
     C                             DDRPSV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:3:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDRPOV <> *BLANK
     C                   IF        FNRPOV <> DDRPOV AND
     C                             DDRPOV <> 'B' OR
     C                             DDRPOV = 'B' AND
     C                             FNRPOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:3:1) = 'Y'
     C                   ENDIF
     C                   IF        DDRPOV <> 'Y' AND
     C                             DDRPOV <> 'N' AND
     C                             DDRPOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:3:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDCISV <> *BLANK
     C                   IF        FNCISV <> DDCISV AND
     C                             DDCISV <> 'B' OR
     C                             DDCISV = 'B' AND
     C                             FNCISV <> ' '
     C                   EVAL      %SUBST(IgnorRec:4:1) = 'Y'
     C                   ENDIF
     C                   IF        DDCISV <> 'Y' AND
     C                             DDCISV <> 'N' AND
     C                             DDCISV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:4:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDCIOV <> *BLANK
     C                   IF        FNCIOV <> DDCIOV AND
     C                             DDCIOV <> 'B' OR
     C                             DDCIOV = 'B' AND
     C                             FNCIOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:4:1) = 'Y'
     C                   ENDIF
     C                   IF        DDCIOV <> 'Y' AND
     C                             DDCIOV <> 'N' AND
     C                             DDCIOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:4:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDCBSV <> *BLANK
     C                   IF        FNCBSV <> DDCBSV AND
     C                             DDCBSV <> 'B' OR
     C                             DDCBSV = 'B' AND
     C                             FNCBSV <> ' '
     C                   EVAL      %SUBST(IgnorRec:5:1) = 'Y'
     C                   ENDIF
     C                   IF        DDCBSV <> 'Y' AND
     C                             DDCBSV <> 'N' AND
     C                             DDCBSV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:5:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDCBOV <> *BLANK
     C                   IF        FNCBOV <> DDCBOV AND
     C                             DDCBOV <> 'B' OR
     C                             DDCBOV = 'B' AND
     C                             FNCBOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:5:1) = 'Y'
     C                   ENDIF
     C                   IF        DDCBOV <> 'Y' AND
     C                             DDCBOV <> 'N' AND
     C                             DDCBOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:5:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDCDSV <> *BLANK
     C                   IF        FNCDSV <> DDCDSV AND
     C                             DDCDSV <> 'B' OR
     C                             DDCDSV = 'B' AND
     C                             FNCDSV <> ' '
     C                   EVAL      %SUBST(IgnorRec:6:1) = 'Y'
     C                   ENDIF
     C                   IF        DDCDSV <> 'Y' AND
     C                             DDCDSV <> 'N' AND
     C                             DDCDSV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:6:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDCDOV <> *BLANK
     C                   IF        FNCDOV <> DDCDOV AND
     C                             DDCDOV <> 'B' OR
     C                             DDCDOV = 'B' AND
     C                             FNCDOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:6:1) = 'Y'
     C                   ENDIF
     C                   IF        DDCDOV <> 'Y' AND
     C                             DDCDOV <> 'N' AND
     C                             DDCDOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:6:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDGCSV <> *BLANK
     C                   IF        FNGCSV <> DDGCSV AND
     C                             DDGCSV <> 'B' OR
     C                             DDGCSV = 'B' AND
     C                             FNGCSV <> ' '
     C                   EVAL      %SUBST(IgnorRec:7:1) = 'Y'
     C                   ENDIF
     C                   IF        DDGCSV <> 'Y' AND
     C                             DDGCSV <> 'N' AND
     C                             DDGCSV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:7:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDGCOV <> *BLANK
     C                   IF        FNGCOV <> DDGCOV AND
     C                             DDGCOV <> 'B' OR
     C                             DDGCOV = 'B' AND
     C                             FNGCOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:7:1) = 'Y'
     C                   ENDIF
     C                   IF        DDGCOV <> 'Y' AND
     C                             DDGCOV <> 'N' AND
     C                             DDGCOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:7:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDIDSV <> *BLANK
     C                   IF        FNIDSV <> DDIDSV AND
     C                             DDIDSV <> 'B' OR
     C                             DDIDSV = 'B' AND
     C                             FNIDSV <> ' '
     C                   EVAL      %SUBST(IgnorRec:8:1) = 'Y'
     C                   ENDIF
     C                   IF        DDIDSV <> 'Y' AND
     C                             DDIDSV <> 'N' AND
     C                             DDIDSV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:8:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDIDOV <> *BLANK
     C                   IF        FNIDOV <> DDIDOV AND
     C                             DDIDOV <> 'B' OR
     C                             DDIDOV = 'B' AND
     C                             FNIDOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:8:1) = 'Y'
     C                   ENDIF
     C                   IF        DDIDOV <> 'Y' AND
     C                             DDIDOV <> 'N' AND
     C                             DDIDOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:8:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDJASV <> *BLANK
     C                   IF        FNJASV <> DDJASV AND
     C                             DDJASV <> 'B' OR
     C                             DDJASV = 'B' AND
     C                             FNJASV <> ' '
     C                   EVAL      %SUBST(IgnorRec:9:1) = 'Y'
     C                   ENDIF
     C                   IF        DDJASV <> 'Y' AND
     C                             DDJASV <> 'N' AND
     C                             DDJASV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:9:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDJAOV <> *BLANK
     C                   IF        FNJAOV <> DDJAOV AND
     C                             DDJAOV <> 'B' OR
     C                             DDJAOV = 'B' AND
     C                             FNJAOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:9:1) = 'Y'
     C                   ENDIF
     C                   IF        DDJAOV <> 'Y' AND
     C                             DDJAOV <> 'N' AND
     C                             DDJAOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:9:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDTESV <> *BLANK
     C                   IF        FNTESV <> DDTESV AND
     C                             DDTESV <> 'B' OR
     C                             DDTESV = 'B' AND
     C                             FNTESV <> ' '
     C                   EVAL      %SUBST(IgnorRec:10:1) = 'Y'
     C                   ENDIF
     C                   IF        DDTESV <> 'Y' AND
     C                             DDTESV <> 'N' AND
     C                             DDTESV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:10:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDTEOV <> *BLANK
     C                   IF        FNTEOV <> DDTEOV AND
     C                             DDTEOV <> 'B' OR
     C                             DDTEOV = 'B' AND
     C                             FNTEOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:10:1) = 'Y'
     C                   ENDIF
     C                   IF        DDTEOV <> 'Y' AND
     C                             DDTEOV <> 'N' AND
     C                             DDTEOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:10:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDTXSV <> *BLANK
     C                   IF        FNTXSV <> DDTXSV AND
     C                             DDTXSV <> 'B' OR
     C                             DDTXSV = 'B' AND
     C                             FNTXSV <> ' '
     C                   EVAL      %SUBST(IgnorRec:11:1) = 'Y'
     C                   ENDIF
     C                   IF        DDTXSV <> 'Y' AND
     C                             DDTXSV <> 'N' AND
     C                             DDTXSV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:11:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDTXOV <> *BLANK
     C                   IF        FNTXOV <> DDTXOV AND
     C                             DDTXOV <> 'B' OR
     C                             DDTXOV = 'B' AND
     C                             FNTXOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:11:1) = 'Y'
     C                   ENDIF
     C                   IF        DDTXOV <> 'Y' AND
     C                             DDTXOV <> 'N' AND
     C                             DDTXOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:11:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDAUSV <> *BLANK
     C                   IF        FNAUSV <> DDAUSV AND
     C                             DDAUSV <> 'B' OR
     C                             DDAUSV = 'B' AND
     C                             FNAUSV <> ' '
     C                   EVAL      %SUBST(IgnorRec:12:1) = 'Y'
     C                   ENDIF
     C                   IF        DDAUSV <> 'Y' AND
     C                             DDAUSV <> 'N' AND
     C                             DDAUSV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:12:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDAUOV <> *BLANK
     C                   IF        FNAUOV <> DDAUOV AND
     C                             DDAUOV <> 'B' OR
     C                             DDAUOV = 'B' AND
     C                             FNAUOV <> ' '
     C                   EVAL      %SUBST(IgnorRec:12:1) = 'Y'
     C                   ENDIF
     C                   IF        DDAUOV <> 'Y' AND
     C                             DDAUOV <> 'N' AND
     C                             DDAUOV <> 'B'
     C                   EVAL      %SUBST(IgnorRec:12:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDHMTV <> *BLANK
     C                   IF        DDHMTV = 'Y'
     C                   IF        FNHMSV = 'N' AND
     C                             FNHMOV = ' ' OR
     C                             FNHMSV = ' ' AND
     C                             FNHMOV = ' ' OR
     C                             FNHMOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:1:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDHMTV = 'N'
     C                   IF        FNHMOV = 'Y' OR
     C                             FNHMSV = ' ' AND
     C                             FNHMOV = ' ' OR
     C                             FNHMSV = 'Y' AND
     C                             FNHMOV = ' '
     C                   EVAL      %SUBST(IgnorRec:1:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDHMTV <> 'Y' AND
     C                             DDHMTV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:1:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDMCTV <> *BLANK
     C                   IF        DDMCTV = 'Y'
     C                   IF        FNMCSV = 'N' AND
     C                             FNMCOV = ' ' OR
     C                             FNMCSV = ' ' AND
     C                             FNMCOV = ' ' OR
     C                             FNMCOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:2:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDMCTV = 'N'
     C                   IF        FNMCOV = 'Y' OR
     C                             FNMCSV = ' ' AND
     C                             FNMCOV = ' ' OR
     C                             FNMCSV = 'Y' AND
     C                             FNMCOV = ' '
     C                   EVAL      %SUBST(IgnorRec:2:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDMCTV <> 'Y' AND
     C                             DDMCTV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:2:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDRPTV <> *BLANK
     C                   IF        DDRPTV = 'Y'
     C                   IF        FNRPSV = 'N' AND
     C                             FNRPOV = ' ' OR
     C                             FNRPSV = ' ' AND
     C                             FNRPOV = ' ' OR
     C                             FNRPOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:3:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDRPTV = 'N'
     C                   IF        FNRPOV = 'Y' OR
     C                             FNRPSV = ' ' AND
     C                             FNRPOV = ' ' OR
     C                             FNRPSV = 'Y' AND
     C                             FNRPOV = ' '
     C                   EVAL      %SUBST(IgnorRec:3:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDRPTV <> 'Y' AND
     C                             DDRPTV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:3:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDCITV <> *BLANK
     C                   IF        DDCITV = 'Y'
     C                   IF        FNCISV = 'N' AND
     C                             FNCIOV = ' ' OR
     C                             FNCISV = ' ' AND
     C                             FNCIOV = ' ' OR
     C                             FNCIOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:4:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDCITV = 'N'
     C                   IF        FNCIOV = 'Y' OR
     C                             FNCISV = ' ' AND
     C                             FNCIOV = ' ' OR
     C                             FNCISV = 'Y' AND
     C                             FNCIOV = ' '
     C                   EVAL      %SUBST(IgnorRec:4:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDCITV <> 'Y' AND
     C                             DDCITV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:4:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDCBTV <> *BLANK
     C                   IF        DDCBTV = 'Y'
     C                   IF        FNCBSV = 'N' AND
     C                             FNCBOV = ' ' OR
     C                             FNCBSV = ' ' AND
     C                             FNCBOV = ' ' OR
     C                             FNCBOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:5:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDCBTV = 'N'
     C                   IF        FNCBOV = 'Y' OR
     C                             FNCBSV = ' ' AND
     C                             FNCBOV = ' ' OR
     C                             FNCBSV = 'Y' AND
     C                             FNCBOV = ' '
     C                   EVAL      %SUBST(IgnorRec:5:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDCBTV <> 'Y' AND
     C                             DDCBTV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:5:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDCDTV <> *BLANK
     C                   IF        DDCDTV = 'Y'
     C                   IF        FNCDSV = 'N' AND
     C                             FNCDOV = ' ' OR
     C                             FNCDSV = ' ' AND
     C                             FNCDOV = ' ' OR
     C                             FNCDOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:6:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDCDTV = 'N'
     C                   IF        FNCDOV = 'Y' OR
     C                             FNCDSV = ' ' AND
     C                             FNCDOV = ' ' OR
     C                             FNCDSV = 'Y' AND
     C                             FNCDOV = ' '
     C                   EVAL      %SUBST(IgnorRec:6:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDCDTV <> 'Y' AND
     C                             DDCDTV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:6:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDGCTV <> *BLANK
     C                   IF        DDGCTV = 'Y'
     C                   IF        FNGCSV = 'N' AND
     C                             FNGCOV = ' ' OR
     C                             FNGCSV = ' ' AND
     C                             FNGCOV = ' ' OR
     C                             FNGCOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:7:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDGCTV = 'N'
     C                   IF        FNGCOV = 'Y' OR
     C                             FNGCSV = ' ' AND
     C                             FNGCOV = ' ' OR
     C                             FNGCSV = 'Y' AND
     C                             FNGCOV = ' '
     C                   EVAL      %SUBST(IgnorRec:7:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDGCTV <> 'Y' AND
     C                             DDGCTV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:7:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDIDTV <> *BLANK
     C                   IF        DDIDTV = 'Y'
     C                   IF        FNIDSV = 'N' AND
     C                             FNIDOV = ' ' OR
     C                             FNIDSV = ' ' AND
     C                             FNIDOV = ' ' OR
     C                             FNIDOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:8:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDIDTV = 'N'
     C                   IF        FNIDOV = 'Y' OR
     C                             FNIDSV = ' ' AND
     C                             FNIDOV = ' ' OR
     C                             FNIDSV = 'Y' AND
     C                             FNIDOV = ' '
     C                   EVAL      %SUBST(IgnorRec:8:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDIDTV <> 'Y' AND
     C                             DDIDTV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:8:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDJATV <> *BLANK
     C                   IF        DDJATV = 'Y'
     C                   IF        FNJASV = 'N' AND
     C                             FNJAOV = ' ' OR
     C                             FNJASV = ' ' AND
     C                             FNJAOV = ' ' OR
     C                             FNJAOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:9:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDJATV = 'N'
     C                   IF        FNJAOV = 'Y' OR
     C                             FNJASV = ' ' AND
     C                             FNJAOV = ' ' OR
     C                             FNJASV = 'Y' AND
     C                             FNJAOV = ' '
     C                   EVAL      %SUBST(IgnorRec:9:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDJATV <> 'Y' AND
     C                             DDJATV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:9:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDTETV <> *BLANK
     C                   IF        DDTETV = 'Y'
     C                   IF        FNTESV = 'N' AND
     C                             FNTEOV = ' ' OR
     C                             FNTESV = ' ' AND
     C                             FNTEOV = ' ' OR
     C                             FNTEOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:10:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDTETV = 'N'
     C                   IF        FNTEOV = 'Y' OR
     C                             FNTESV = ' ' AND
     C                             FNTEOV = ' ' OR
     C                             FNTESV = 'Y' AND
     C                             FNTEOV = ' '
     C                   EVAL      %SUBST(IgnorRec:10:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDTETV <> 'Y' AND
     C                             DDTETV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:10:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDTXTV <> *BLANK
     C                   IF        DDTXTV = 'Y'
     C                   IF        FNTXSV = 'N' AND
     C                             FNTXOV = ' ' OR
     C                             FNTXSV = ' ' AND
     C                             FNTXOV = ' ' OR
     C                             FNTXOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:11:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDTXTV = 'N'
     C                   IF        FNTXOV = 'Y' OR
     C                             FNTXSV = ' ' AND
     C                             FNTXOV = ' ' OR
     C                             FNTXSV = 'Y' AND
     C                             FNTXOV = ' '
     C                   EVAL      %SUBST(IgnorRec:11:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDTXTV <> 'Y' AND
     C                             DDTXTV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:11:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
      **
     C                   IF        DDAUTV <> *BLANK
     C                   IF        DDAUTV = 'Y'
     C                   IF        FNAUSV = 'N' AND
     C                             FNAUOV = ' ' OR
     C                             FNAUSV = ' ' AND
     C                             FNAUOV = ' ' OR
     C                             FNAUOV = 'N'
     C                   EVAL      %SUBST(IgnorRec:12:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDAUTV = 'N'
     C                   IF        FNAUOV = 'Y' OR
     C                             FNAUSV = ' ' AND
     C                             FNAUOV = ' ' OR
     C                             FNAUSV = 'Y' AND
     C                             FNAUOV = ' '
     C                   EVAL      %SUBST(IgnorRec:12:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDAUTV <> 'Y' AND
     C                             DDAUTV <> 'N'
     C                   EVAL      %SUBST(IgnorRec:12:1) = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        %SCAN(' ' : USindicia) <> *ZERO and
     C                             (%SCAN('Y' : USindicia) <> *ZERO or
     C                              %SCAN('N' : USindicia) <> *ZERO)
     C                             OR
     C                             %SCAN(' ' : SystemDS) <> *ZERO and
     C                             (%SCAN('Y' : SystemDS) <> *ZERO or
     C                              %SCAN('N' : SystemDS) <> *ZERO or
     C                              %SCAN('B' : SystemDS) <> *ZERO)
     C                             OR
     C                             %SCAN(' ' : OverrideDS) <> *ZERO and
     C                             (%SCAN('Y' : OverrideDS) <> *ZERO or
     C                              %SCAN('N' : OverrideDS) <> *ZERO or
     C                              %SCAN('B' : OverrideDS) <> *ZERO)
     C
     C                   MOVE      *ZEROS        USidx             2 0
 
     C                   DO        12
     C                   EVAL      USidx = USidx + 1
     C                   IF        %SUBST(USindicia:USidx:1) = *BLANK
     C                             AND
     C                             %SUBST(SystemDS:USidx:1) = *BLANK
     C                             AND
     C                             %SUBST(OverrideDS:USidx:1) = *BLANK
     C                   EVAL      %SUBST(IgnorRec:USidx:1) = 'Y'
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
 
     C                   IF        IgnorRec = 'YYYYYYYYYYYY'
     C                   MOVE      *BLANK        FNNAHO
     C                   ENDIF
      *
      ** End of File
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ERDCUST       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @CUSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKI
     C                   MOVE      '0'           @INKN
     C                   EVAL      *In36      = @in36
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
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
      * INPUT PARAMETERS :
      * RETURN CODE
      * ACTION CODE
      * Custo Ref Pointer
      * BUILD SUB-FILE
      * READ SUBFILE RECORD
      * Browse screen
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCUSN           10
     C                   PARM                    @BDSFL            1
     C                   PARM                    @RDSFL            1
     C                   PARM                    @IN36             1
     C                   PARM                    PMODE             1                        MD029849
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * ERROR MESSAGE
      * OPTION SELECTED
      * Custo Ref. selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @CUSEL           10
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKN             1
      *
      ** Initialize program name
     C                   MOVEL     'SDFTNHBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
     C                   MOVE      '1'           *IN94
     C                   MOVEL     '*'           DDPGMQ
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      *IN55 = '0'                                              MD029849
     C                   IF        PMODE = 'E'                                              MD029849
     C                   EVAL      *IN55 = '1'                                              MD029849
     C                   ENDIF                                                              MD029849
                                                                                            MD029849
     C                   MOVE      *BLANK        DDHMTV
     C                   MOVE      *BLANK        DDHMSV
     C                   MOVE      *BLANK        DDHMOV
     C                   MOVE      *BLANK        DDMCTV
     C                   MOVE      *BLANK        DDMCSV
     C                   MOVE      *BLANK        DDMCOV
     C                   MOVE      *BLANK        DDRPTV
     C                   MOVE      *BLANK        DDRPSV
     C                   MOVE      *BLANK        DDRPOV
     C                   MOVE      *BLANK        DDCITV
     C                   MOVE      *BLANK        DDCISV
     C                   MOVE      *BLANK        DDCIOV
     C                   MOVE      *BLANK        DDCBTV
     C                   MOVE      *BLANK        DDCBSV
     C                   MOVE      *BLANK        DDCBOV
     C                   MOVE      *BLANK        DDCDTV
     C                   MOVE      *BLANK        DDCDSV
     C                   MOVE      *BLANK        DDCDOV
     C                   MOVE      *BLANK        DDGCTV
     C                   MOVE      *BLANK        DDGCSV
     C                   MOVE      *BLANK        DDGCOV
     C                   MOVE      *BLANK        DDIDTV
     C                   MOVE      *BLANK        DDIDSV
     C                   MOVE      *BLANK        DDIDOV
     C                   MOVE      *BLANK        DDJATV
     C                   MOVE      *BLANK        DDJASV
     C                   MOVE      *BLANK        DDJAOV
     C                   MOVE      *BLANK        DDTETV
     C                   MOVE      *BLANK        DDTESV
     C                   MOVE      *BLANK        DDTEOV
     C                   MOVE      *BLANK        DDTXTV
     C                   MOVE      *BLANK        DDTXSV
     C                   MOVE      *BLANK        DDTXOV
     C/COPY WNCPYSRC,SDCUSDBC03
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      *
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2013
