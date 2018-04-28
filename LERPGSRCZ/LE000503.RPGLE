     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Batch Update of Trailer Files')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000503 - Midas LE Batch Update of Trailer Files            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD022860           Date 14Oct13               *
      *  Prev Amend No. MD022640           Date 01Oct13               *
      *                 MD021423B          Date 04Sep13               *
      *                 MD021423 *CREATE   Date 21Aug13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022860 - Result variable too small to hold result          *
      *  MD022640 - Update trailer for LOAM SC/BC events              *
      *  MD021423B - Abnormally long run of PDCL/MAPY processing      *
      *              Corrected trailer updates                        *
      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
      *             components                                        *
      *                                                               *
      *****************************************************************
      *
      ** Transactions sent to MQ Log File
     FLEMQLGLB  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Customer Loans Trailer File
     FCLOAN     UF A E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANCKF)
     F                                     COMMIT
      *
      ** Loan Amendments for Updating
     FLELOMKL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSDKF)
     F                                     RENAME(LOAMSZ1F:LELOMZF)
     F                                     COMMIT
      ** Midas LE Loan Amendments file
      *
     FLOAMS     UF A E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSDKF)
     F                                     RENAME(LOAMSZ1F:LOAMSZF)
     F                                     COMMIT
      *
      ** Midas LE Loans with New Events File
     FCLOANE    UF A E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANHHF)
     F                                     RENAME(CLOANZ1F:LELWNEZ0)
     F                                     COMMIT
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      ** Data structure for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ***  First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ***  Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+
 
     D DSACTN          S              1    INZ('I')
     D P@NATN          S              5  0
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Read all records in LEMQLGPD whose status is 'P'
      *
     C                   EVAL      *IN50 = *OFF
     C     *IN50         DOWEQ     *OFF
     C                   READ      LEMQLGPF                               50
      *
     C     *IN50         IFEQ      *OFF
      *
      ** Update different trailer files
      *
     C                   EXSR      SrUpdTrailer
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
      * SrUpdTrailer - Subroutine to Update Trailer Files             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:  xsCLOANZ1, xuCLOANZ1, xsLELWNZ, xuLELWNZ              *
      *         xsLOAMSZ1, xuLOAMSZ1, xsLELOMZ, uLELOMZ               *
      *                                                               *
      *****************************************************************
     C     SrUpdTrailer  BEGSR
      *
     C                   MOVEL     LGTGTT        TYPE              4
 
     C                   SELECT
      *
     C                   WHEN      TYPE = 'CLIP'
     C                   EXSR      xsCLOANZ1
     C                   EXSR      xuCLOANZ1
     C                   EXSR      xsLELWNZ
     C                   EXSR      xuLELWNZ
      *
     C                   WHEN      TYPE = 'LOAM' AND LGLOAN <> *BLANKS
     C                   EXSR      xsLOAMSZ1
     C                   EXSR      xuLOAMSZ1
     C                   EXSR      xsLELOMZ
     C                   EXSR      xuLELOMZ
 
     C                   WHEN      TYPE = 'LOAM' AND LGLOAN = *BLANKS                       MD022640
     C                             AND (LGATYP = 'SC' OR LGATYP = 'BC')                     MD022640
     C                   EXSR      xsLOAMSZ1                                                MD022640
     C                   EXSR      xuLOAMSZ1                                                MD022640
     C                   EXSR      xsLELOMZ                                                 MD022640
     C                   EXSR      xuLELOMZ                                                 MD022640
                                                                                            MD022640
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xsCLOANZ1 - Set Loan Details Trailer File                     *
      *                                                               *
      * Called by: SrUpdTrailer                                       *
      *                                                               *
      * Calls: *PSSR, GLZADD                                          *
      *                                                               *
      *****************************************************************
     C     xsCLOANZ1     BEGSR
      *
      ***  Access trailer record
      *
     C                   MOVE      'Z'           WEPAR
     C                   MOVE      '999999'      WALON
     C                   MOVE      '999999Z'     WLTRL             7
     C     WKLON         CHAIN (E) CLOAN                              89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECI          ANDNE     'T'
     C     *LOCK         IN        LDA
     C                   MOVE      WLTRL         DBKEY
     C                   MOVEL     'CLOAN   '    DBFILE
     C                   EVAL      DBASE       = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Set up relevant total fields
      *
     C     DSACTN        IFEQ      'I'
     C                   ADD       2             NORE
     C                   ADD       2             NINS
     C                   ADD       2             NLRA
     C                   ELSE
     C                   ADD       2             NDEL
     C                   SUB       2             NLRA
     C                   ENDIF
      *
      ***  Set up amount fields for insert
      *
     C     DSACTN        IFEQ      'I'
     C     LGAMNT        DIV       1000          ZZAMT            15 3
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VRIF          ZZTOTI
     C                   Z-ADD     VRIL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRIF
     C                   Z-ADD     ZZTOTD        VRIL
     C     LGAMNT        DIV       1000          ZZAMT
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
      *
      ***  Set up amount fields for reversal
      *
     C                   ELSE
     C     LGAMNT        DIV       1000          ZZAMT
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VRDF          ZZTOTI
     C                   Z-ADD     VRDL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRDF
     C                   Z-ADD     ZZTOTD        VRDL
     C     LGAMNT        DIV       1000          ZZAMT
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      GLZSUB
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xuCLOANZ1 - Update Details Trailer File                       *
      *                                                               *
      * Called by: SrUpdTrailer                                       *
      *                                                               *
      * Calls: *PSSR, GLZADD                                          *
      *                                                               *
      *****************************************************************
     C     xuCLOANZ1     BEGSR
      *
      ***  Update CLOAN trailer
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      DSACTN        CHTP
     C                   Z-ADD     1             TNLU
     C                   UPDATE(E) CLOANZ1F
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'CLOANZ1'
     C                   EVAL      DBASE       = 002
     C                   EVAL      DBKEY = WLTRL
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xsLOAMSZ1 - Set Loan Amendments Trailer File                  *
      *                                                               *
      * Called by: SrUpdTrailer                                       *
      *                                                               *
      * Calls: *PSSR, GLZADD                                          *
      *                                                               *
      *****************************************************************
     C     xsLOAMSZ1     BEGSR
 
      ** Retrieve Trailer Records.
 
     C                   EVAL       KLNRF      = '999999'
     C                   EVAL       KVDAT      = 99999
     C                   EVAL       KLASN      = 999
     C     KLOAMS        CHAIN (E) LOAMS
 
     C                   IF        NOT %FOUND(LOAMS)
     C                   EVAL      DBFILE      = 'LOAMS'
     C                   EVAL      DBASE       = 003
     C                   EVAL      DBKEY       = '999999'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Increment Counts & Set Hash Totals.
 
     C                   SELECT
     C                   WHEN      DSACTN      = 'I'
     C**********         EVAL      NORE       += 1                                          MD022860
     C**********         EVAL      NINS       += 1                                          MD022860
     C**********         EVAL      NLRA       += 1                                          MD022860
     C                   ADD       1             NORE                                       MD022860
     C                   ADD       1             NINS                                       MD022860
     C                   ADD       1             NLRA                                       MD022860
 
     C**********         EVAL      ZZTOTI      = VRIF                                       MD022860
     C**********         EVAL      ZZTOTD      = VRIL                                       MD022860
     C                   Z-ADD     VRIF          ZZTOTI                                     MD022860
     C                   Z-ADD     VRIL          ZZTOTD                                     MD022860
     C                   EXSR      GLZADD
     C**********         EVAL      VRIF        = ZZTOTI                                     MD022860
     C**********         EVAL      VRIL        = ZZTOTD                                     MD022860
     C                   Z-ADD     ZZTOTI        VRIF                                       MD022860
     C                   Z-ADD     ZZTOTD        VRIL                                       MD022860
 
     C**********         EVAL      ZZTOTI      = VRRF                                       MD022860
     C**********         EVAL      ZZTOTD      = VRRL                                       MD022860
     C                   Z-ADD     VRRF          ZZTOTI                                     MD022860
     C                   Z-ADD     VRRL          ZZTOTD                                     MD022860
 
     C                   WHEN      DSACTN      = 'R'
     C**********         EVAL      NDEL       += 1                                          MD022860
     C**********         EVAL      NLRA       -= 1                                          MD022860
     C                   ADD       1             NDEL                                       MD022860
     C                   SUB       1             NLRA                                       MD022860
 
     C**********         EVAL      ZZTOTI      = VRDF                                       MD022860
     C**********         EVAL      ZZTOTD      = VRDL                                       MD022860
     C                   Z-ADD     VRDF          ZZTOTI                                     MD022860
     C                   Z-ADD     VRDL          ZZTOTD                                     MD022860
     C                   ENDSL
 
     C**********         EVAL      ZZAMT       = LGAMNT / 1000                              MD022860
     C     LGAMNT        DIV       1000          ZZAMT                                      MD022860
 
     C                   IF        ZZAMT       < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
      ** Adjust Hash Total by Value of Records after Insert/Reversal.
 
     C                   EXSR      GLZADD
 
      ** Set Appropiate Hash Total Fields.
 
     C                   SELECT
     C                   WHEN      DSACTN      = 'I'
     C**********         EVAL      VRRF        = ZZTOTI                                     MD022860
     C**********         EVAL      VRRL        = ZZTOTD                                     MD022860
     C                   Z-ADD     ZZTOTI        VRRF                                       MD022860
     C                   Z-ADD     ZZTOTD        VRRL                                       MD022860
 
     C                   WHEN      DSACTN      = 'R'
     C**********         EVAL      VRDF        = ZZTOTI                                     MD022860
     C**********         EVAL      VRDL        = ZZTOTD                                     MD022860
     C                   Z-ADD     ZZTOTI        VRDF                                       MD022860
     C                   Z-ADD     ZZTOTD        VRRL                                       MD022860
     C                   ENDSL
 
      ** Set Last Change Details.
 
     C                   EVAL      LCD         = BJRDNB
     C                   EVAL      CHTP        = 'A'
 
      ** Set Transaction Number of Last Update.
 
     C                   EVAL      TNLU        = P@NATN
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xsLELOMZ - Set Loan Amendments Trailer File .                 *
      *                                                               *
      * Called by: SrUpdTrailer                                       *
      *                                                               *
      * Calls: *PSSR, GLZADD                                          *
      *                                                               *
      *****************************************************************
     C     xsLELOMZ      BEGSR
 
      ** Retrieve Trailer Records.
 
     C                   EVAL       KLNRF      = '999999'
     C                   EVAL       KVDAT      = 99999
     C                   EVAL       KLASN      = 999
     C     KLOMKL3       CHAIN (E) LELOMKL3
 
     C                   IF        NOT %FOUND(LELOMKL3)
     C                   EVAL      DBFILE      = 'LELOMKL3'
     C                   EVAL      DBASE       = 004
     C                   EVAL      DBKEY       = '999999'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Increment Counts & Set Hash Totals.
 
     C                   SELECT
     C                   WHEN      DSACTN      = 'I'
     C**********         EVAL      NORE       += 1                                          MD022860
     C**********         EVAL      NINS       += 1                                          MD022860
     C**********         EVAL      NLRA       += 1                                          MD022860
     C                   ADD       1             NORE                                       MD022860
     C                   ADD       1             NINS                                       MD022860
     C                   ADD       1             NLRA                                       MD022860
 
     C**********         EVAL      ZZTOTI      = VRRF                                       MD022860
     C**********         EVAL      ZZTOTD      = VRRL                                       MD022860
     C                   Z-ADD     VRRF          ZZTOTI                                     MD022860
     C                   Z-ADD     VRRL          ZZTOTD                                     MD022860
 
     C                   WHEN      DSACTN      = 'R'
     C**********         EVAL      NDEL       += 1                                          MD022860
     C**********         EVAL      NLRA       -= 1                                          MD022860
     C                   ADD       1             NDEL                                       MD022860
     C                   SUB       1             NLRA                                       MD022860
 
     C**********         EVAL      ZZTOTI      = VRDF                                       MD022860
     C**********         EVAL      ZZTOTD      = VRDL                                       MD022860
     C                   Z-ADD     VRDF          ZZTOTI                                     MD022860
     C                   Z-ADD     VRDL          ZZTOTD                                     MD022860
     C                   ENDSL
 
     C**********         EVAL      ZZAMT       = LGAMNT / 1000                              MD022860
     C     LGAMNT        DIV       1000          ZZAMT                                      MD022860
 
     C                   IF        ZZAMT       < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
      ** Adjust Hash Total by Value of Records after Insert/Reversal.
 
     C                   EXSR      GLZADD
 
      ** Set Appropiate Hash Total Fields.
 
     C                   SELECT
     C                   WHEN      DSACTN      = 'I'
     C**********         EVAL      VRRF        = ZZTOTI                                     MD022860
     C**********         EVAL      VRRL        = ZZTOTD                                     MD022860
     C                   Z-ADD     ZZTOTI        VRRF                                       MD022860
     C                   Z-ADD     ZZTOTD        VRRL                                       MD022860
 
     C                   WHEN      DSACTN      = 'R'
     C**********         EVAL      VRDF        = ZZTOTI                                     MD022860
     C**********         EVAL      VRDL        = ZZTOTD                                     MD022860
     C                   Z-ADD     ZZTOTI        VRDF                                       MD022860
     C                   Z-ADD     ZZTOTD        VRDL                                       MD022860
     C                   ENDSL
 
      ** Set Last Change Details.
 
     C                   EVAL      LCD         = BJRDNB
     C                   EVAL      CHTP        = 'A'
 
      ** Set Transaction Number of Last Update.
 
     C                   EVAL      TNLU        = P@NATN
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xuLOAMSZ1 - Update Loan Amendment Trailer Record.             *
      *                                                               *
      * Called by: SrUpdTrailer                                       *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xuLOAMSZ1     BEGSR
 
      ** Update Record.
 
     C                   UPDATE(E) LOAMSZF
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'LOAMSZ1'
     C                   EVAL      DBASE       = 005
     C                   EVAL      DBKEY = KLNRF +
     C                                     %CHAR(KVDAT) +
     C                                     %CHAR(KLASN)
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xuLELOMZ - Update Loan Amendment Trailer Record.              *
      *                                                               *
      * Called by: SrUpdTrailer                                       *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xuLELOMZ      BEGSR
 
      ** Update Record.
 
     C                   UPDATE(E) LELOMZF
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'LELOMZPD'
     C                   EVAL      DBASE       = 006
     C                   EVAL      DBKEY = KLNRF +
     C                                     %CHAR(KVDAT) +
     C                                     %CHAR(KLASN)
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xsLELWNZ - Update Loan Amendment Trailer Record.              *
      *                                                               *
      * Called by: SrUpdTrailer                                       *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xsLELWNZ      BEGSR
      *
      ** Access trailer record
     C                   MOVE      'Z'           WEPAR
     C                   MOVE      '999999'      WALON
     C                   MOVE      '999999Z'     WLTRL             7
     C     WKLON         CHAIN (E) CLOANE                             89
      *
      ** Insert trailer record for LELWNEZ1
     C     *IN89         IFEQ      '1'
     C                   CLEAR                   LELWNEZ0
     C                   MOVE      'T'           RECI
     C                   MOVE      '999999'      LNRF
     C                   MOVE      'Z'           RCDT
     C                   Z-ADD     1             NORE
     C                   Z-ADD     1             NINS
     C                   Z-ADD     1             NLRA
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   Z-ADD     1             TNLU
     C                   WRITE     LELWNEZ0
      ** Set pointer to the new record for update
     C     WKLON         CHAIN     CLOANE                             89
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xuLELWNZ - Update Loan Amendment Trailer Record.              *
      *                                                               *
      * Called by: SrUpdTrailer                                       *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xuLELWNZ      BEGSR
      *
      ***  Set up amount fields for insert
      *
     C                   Z-ADD     VRIF          ZZTOTI
     C                   Z-ADD     VRIL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRIF
     C                   Z-ADD     ZZTOTD        VRIL
     C     LGAMNT        DIV       1000          ZZAMT
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
      *
     C**********         ADD       1             NORE                                      MD021423B
     C                   ADD       2             NORE                                      MD021423B
     C**********         ADD       1             NINS                                      MD021423B
     C                   ADD       2             NINS                                      MD021423B
     C**********         ADD       1             NLRA                                      MD021423B
     C                   ADD       2             NLRA                                      MD021423B
      *
     C                   Z-ADD     BJRDNB        LCD
     C**********         MOVE      'I'           CHTP                                      MD021423B
     C                   MOVE      'A'           CHTP                                      MD021423B
     C                   Z-ADD     1             TNLU
     C                   UPDATE    LELWNEZ0
      *
     C                   ENDSR
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    ProgramName      10
      *
     C     KLOAMS        KLIST
     C                   KFLD                    KLNRF             6
     C                   KFLD                    KVDAT             5 0
     C                   KFLD                    KLASN             3 0
 
     C     KLOMKL3       KLIST
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
     C                   KFLD                    KLASN
 
     C     WKLON         KLIST
     C                   KFLD                    WALON             6
     C                   KFLD                    WEPAR             1
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE       = 007
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUB  -  Subtracts an amount (ZZAMT) from the total         *
      *****************************************************************
     C     GLZSUB        BEGSR
      *
      ***  Just reverse the 'sign' and add
      *
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   EXSR      GLZADD
     C                   Z-SUB     ZZAMT         ZZAMT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZADD  -  Adds an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)*
      *****************************************************************
     C     GLZADD        BEGSR
      *
     C     ZZAMT         IFNE      *ZERO
      *
      ***  Split ZZAMT into integer and decimal fields
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   MOVE      ZZAMT         ZZAMTD            3 0
      *
      ***  Both ZZAMTI and ZZAMTD contain a 'sign' zone now
      *
     C                   EXSR      GLZSUM
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUM  -  Carries out the addition of the amounts            *
      *****************************************************************
     C     GLZSUM        BEGSR
      *
      ***  Save values of indicators to be used in the program
      *
     C                   MOVE      *IN91         WIN91             1
     C                   MOVE      *IN92         WIN92             1
     C                   MOVE      *IN93         WIN93             1
     C                   MOVE      *IN94         WIN94             1
     C                   MOVE      *IN95         WIN95             1
     C                   MOVE      *IN96         WIN96             1
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
      *
      ***  Determine sign of ZZAMTI and ZZAMTD, 92 if neg
      *
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
      *
      ***  Determine sign of ZZTOTI and ZZTOTD, 91 if neg
      *
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
      *
      ***  If ZZTOTAL is zero, return ZZAMOUNT
      *
     C   93              Z-ADD     ZZAMTI        ZZTOTI           15 0
     C   93              Z-ADD     ZZAMTD        ZZTOTD            3 0
     C   93              GOTO      ZZSEND
      *
      ***  If signs differ, bypass overflow checks
      *
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93
     C*
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
      *
      ***  If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occured
      *
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
      *
      ***  If O/F zeroise ZZAMT, Ind '99' set and ZZTOT fields left intact
      *
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
      *
      ***  The 'signs' are different
      *
     C     ZZOFPS        TAG
      *
      ***  If ZZAMT was negative, make it pos. to como with ZZTOT
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
      *
      ***  If ZZTOT was negative, make it pos. to comp with ZZAMT.
      *
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
      *
      ***  Both ZZAMT and ZZTOT are now positive
      *
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
      *
      ***  If ZZTOT eq. ZZAMT return ZERO.
      *
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
      *
      ***  If ZZTOT gt. ZZAMT.
      *
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
      *
      ***  If ZZAMT gt. ZZTOT.
      *
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
      *
      ***  Reverse sign of ZZTOT if larger I/P fields were negative
      *
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
      *
      ***  Restore sign of ZZAMTI & ZZAMTD if it was reversed
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG
      *
      ***  If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.
      *
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
      *
      ***  Restore previous indicator values
      *
     C                   MOVE      WIN91         *IN91
     C                   MOVE      WIN92         *IN92
     C                   MOVE      WIN93         *IN93
     C                   MOVE      WIN94         *IN94
     C                   MOVE      WIN95         *IN95
     C                   MOVE      WIN96         *IN96
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
