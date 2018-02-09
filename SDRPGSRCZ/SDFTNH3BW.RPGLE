     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD US Indicia Comment History           '')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDFTNH3BW - US Indicia Comment History Browse                *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDINCNL1  IF   E           K DISK    INFSR(*PSSR)
 
     FSDFTNHHDF CF   E             WORKSTN SFILE(SDFTNHS1:DDRRN)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D/COPY ZACPYSRC,FVAL_ARRAY
 
     D/COPY ZACPYSRC,APICTLARR
 
     D/COPY ZACPYSRC,MSGHNDDCL
 
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
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** New Non-A/C Holder in File Format
     D NwNaFilFmt    E DS                  Extname(SDVNAHLPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DDNAHO          S             10A
     D DDSCDT          S              5P 0
     D DDSEQN          S              3S 0
     D DDCDAT2         S              5P 0
     D WLOOP           S              1A
     D WWUSIN          S             38A
     D WWOVVA          S              1A
     D WWOVUP          S             10A
     D WWOVDT          S              6A
     D WWOVTM          S              6A
     D WWCOMM          S             64A
     D WINKC           S              1A
     D WINKQ           S              1A
     D WINKR           S              1A
     D WINKT           S              1A
     D DDRRN           S              5P 0
     D WWCNT           S              3P 0
     D WWEOF           S              1A
     D WWERR           S              1P 0
     D ZDAYNO          S              5P 0
     D ZDATEX          S              6P 0
     D ZADATE          S              7A
     D LENGTH1         S              3P 0
     D START           S              3P 0
     D LENGTH2         S              3P 0
     D TRANSLATE       S              1A
     D TRIM            S              1A
     D WILD            S              1A
     D RESULT          S              3P 0
     D ZDATE           S              6A
     D SelDate         S              5P 0
     D Errorflag       S              1A
     D ZALIGNOK        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D Retcd           S              7A
     D PDetails        S            800A
     D WRTCD           S              7A
     D WOPTN           S              7A
     D DDCTIM2         S              6A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Build Sub-file
 
     C                   EVAL      WLOOP = 'Y'
 
     C                   DOW       WLOOP = 'Y'
     C                   EXSR      BLDSFL
     C                   EVAL      WLOOP = 'Y'
     C                   ENDDO
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * BLDSFL - BUILD SUBFILE                                        *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: ZDATE2, RDARCH                                         *
      *                                                               *
      *****************************************************************
 
     C     BLDSFL        BEGSR
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             DDRRN
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDFTNHS0
     C                   MOVE      '0'           *IN97
 
     C                   EVAL      DDNAHO = NANAHO
     C                   EVAL      FCNAHO = NANAHO
     C                   EVAL      FCNARN = NANARN
     C                   EVAL      FCNATW = NANATW
 
     C                   EVAL      KUSIN = SNUSIN
     C                   EVAL      DDOVDT2 = *ZERO
     C                   IF        SNOVDT <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SNOVDT        ZFIELD
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      6             ZADIG
 
     C                   IF        ZALIGNOK = 'Y'
     C                   MOVE      ZFIELD        ZDATE
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM      *ZERO         SelDate
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C                   ELSE
     C                   Z-ADD     0             SelDATE
     C                   ENDIF
     C                   EVAL      DDOVDT2 = SelDate
     C                   ELSE
     C                   EVAL      DDOVDT2 = 99999
 
     C                   ENDIF
 
     C                   IF        SNOVTM <> *BLANK AND
     C                             SNOVDT <> *BLANK
     C                   TESTN                   SNOVTM               9191
     C                   IF        *IN91 <> '1'
     C                   MOVE      '000000'      DDOVTM2
     C                   ELSE
     C                   MOVE      SNOVTM        DDOVTM2
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '999999'      DDOVTM2
     C                   ENDIF
 
      ** Set file pointer on key displayed on screen.
 
     C     KINCH         SETLL     SDINCNL1
 
      ** Read account review comment history
 
     C                   EXSR      RDARCH
 
      ** set up message 'no data to display'
 
     C                   MOVE      *OFF          *IN80
     C                   IF        WWEOF = 'Y' OR
     C                             INNAHO <> DDNAHO
     C                   MOVE      *ON           *IN80
     C                   END
 
      **  Set on ROLLUP indicator to drive initial loop.
 
     C                   MOVE      '1'           *IN98
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 is input.
 
     C     *IN98         DOWEQ     '1'
     C     WLOOP         ANDEQ     'Y'
 
      ** Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             WWCNT
     C                   IF        WWEOF = 'Y'
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF
 
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
 
     C                   DOW       WWEOF <> 'Y' AND
     C                             WWCNT < 3 AND
     C                             INNAHO = DDNAHO
 
      ** Increment the subfile record no. and records written fields.
 
     C                   ADD       1             DDRRN
     C                   ADD       1             WWCNT
 
      ** Write the customer to the subfile.
 
     C                   Z-ADD     DDRRN         DDSFRN
 
     C                   MOVE      INUSTM        DDOVTM
     C                   EVAL      DDUSIN = INUSIN
     C                   EVAL      DDOVVA = INUSOV
     C                   EVAL      DDOVUP = INUSUN
     C                   MOVE      INUSDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEX        DDOVDT
     C                   EVAL      DDCOM1 = %SUBST(INUSCO:1:64)
     C                   EVAL      DDCOM2 = %SUBST(INUSCO:65:64)
 
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDFTNHS1
 
      ** Read account review comment history
 
     C                   EXSR      RDARCH
     C                   ENDDO
 
     C                   IF        INNAHO <> DDNAHO
     C                   EVAL      WWEOF = 'Y'
     C                   MOVE      '1'           *IN96
     C                   ENDIF
 
      ** Set up footer toggle text and write the footer
 
     C                   WRITE     SDFTNHF1
 
      ** If there is no data to display, set on SFLCLR condition and
      ** write the subfile control record
 
     C                   IF        WWCNT = 0 AND
     C                             DDRRN = 0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDFTNHS0
     C                   MOVE      '0'           *IN97
     C                   Z-ADD     1             DDRRN
     C                   Z-ADD     1             DDSFRN
 
      ** write to the subfile with non-display set on
 
     C                   TIME                    DDTIME
     C                   MOVE      '1'           *IN93
     C                   WRITE     SDFTNHS1
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDFTNHS0
     C                   ELSE
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   TIME                    DDTIME
     C                   WRITE     SDFTNHS0
     C                   ENDIF
 
     C                   EVAL      WWUSIN = SNUSIN
     C                   EVAL      WWOVVA = SNOVVA
     C                   EVAL      WWOVUP = SNOVUP
     C                   EVAL      WWOVDT = SNOVDT
     C                   EVAL      WWOVTM = SNOVTM
     C                   EVAL      WWCOMM = SNCOMM1
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      SDFTNHS0
 
      ** If F3, bypass further processing.
     C                   IF        *INKC = '1'
     C                   MOVEL     '1'           WINKC
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      ** If F5, refresh
     C                   IF        *INKE = '1'
     C                   EVAL      SNUSIN = *BLANKS
     C                   EVAL      SNOVVA = *BLANKS
     C                   EVAL      SNOVUP = *BLANKS
     C                   EVAL      SNOVDT = *BLANKS
     C                   EVAL      SNOVTM = *BLANKS
     C                   EVAL      SNCOMM1 = *BLANKS
     C                   EVAL      WLOOP = 'N'
     C                   ENDIF
 
      ** If F16, bypass further processing.
     C                   IF        *INKQ = '1'
     C                   MOVEL     '1'           WINKQ
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      ** If F17, bypass further processing.
     C                   IF        *INKR = '1'
     C                   MOVEL     '1'           WINKR
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      ** If F19, bypass further processing.
     C                   IF        *INKT = '1'
     C                   MOVEL     '1'           WINKT
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   IF        SNUSIN <> WWUSIN OR
     C                             SNOVVA <> WWOVVA OR
     C                             SNOVUP <> WWOVUP OR
     C                             SNOVDT <> WWOVDT OR
     C                             SNOVTM <> WWOVTM OR
     C                             SNCOMM1 <> WWCOMM
     C                   EVAL      WLOOP = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RDARCH - Read Account Review Comment History                  *
      *                                                               *
      * Called by: BLDSFL                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RDARCH        BEGSR
 
      **  Reset End of File and skip record indicator
 
     C                   MOVE      *BLANK        WWEOF
     C                   Z-ADD     0             WWERR
 
      **  Read the file initially - if WWEOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
 
     C                   DOU       WWEOF = 'Y' OR
     C                             WWERR = *ZERO
 
     C                   Z-ADD     0             WWERR
     C                   READ      SDINCNL1                               96
 
     C     SNUSIN        IFNE      *BLANK
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    INUSIN
     C                   PARM      38            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SNUSIN
     C                   PARM      38            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
 
     C     RESULT        IFLT      1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
 
      ** Select according to override value mask
 
     C                   IF        SNOVVA <> *BLANK
     C                   IF        INUSOV <> SNOVVA
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
 
      ** Select according to comment user name mask
 
     C                   IF        SNOVUP <> *BLANK
     C                   IF        INUSUN <> SNOVUP
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
 
     C     SNCOMM1       IFNE      *BLANK
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    INUSCO
     C                   PARM      128           LENGTH1
     C                   PARM      1             START
     C                   PARM                    SNCOMM1
     C                   PARM      64            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
 
     C     RESULT        IFLT      1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
 
     C                   WRITE     SDFTNHF1
 
     C                   IF        *IN96 = '1'
     C                   MOVEL     'Y'           WWEOF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      * Called by: BLDSFL                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEX
     C                   PARM                    ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
     C                   PARM                    RetCodeIn
     C                   PARM                    NwNaFilFmt
     C                   PARM                    WINKC
     C                   PARM                    WINKQ
     C                   PARM                    WINKR
     C                   PARM                    WINKT
 
      ** Initialize program name
     C                   MOVEL     'SDFTNH3BW'   DBPGM
 
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
 
      ** Define Key List KINCH
     C     KINCH         KLIST
     C                   KFLD                    DDNAHO
     C                   KFLD                    KUSIN            38
     C                   KFLD                    DDOVDT2           5 0
     C                   KFLD                    DDOVTM2           6
 
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        WRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     WOPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      BJMRDT = BJMRDT
     C                   EVAL      SNUSIN = *BLANKS
     C                   EVAL      SNOVVA = *BLANKS
     C                   EVAL      SNOVUP = *BLANKS
     C                   EVAL      SNOVDT = *BLANKS
     C                   EVAL      SNOVTM = *BLANKS
     C                   EVAL      SNCOMM1 = *BLANKS
     C                   MOVE      '0'           WINKC
     C                   MOVE      '0'           WINKQ
     C                   MOVE      '0'           WINKR
     C                   MOVE      '0'           WINKT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
