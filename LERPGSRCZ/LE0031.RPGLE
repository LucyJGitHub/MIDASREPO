     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE initialisation program for CLE031')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE0031 - Initialise the additional fields in files used by   *
      *           CLE031.                                             *
      *                                                               *
      *  Function:  This module sets up the following:                *
      *                                                               *
      *  File  = FCLTYFM                                              *
      *                                                               *
      *       Field      Default Value                                *
      *       COAG       'N'                                          *
      *       FCAG       'N'                                          *
      *       PHAG       'N'                                          *
      *       SCAG       'N'                                          *
      *       REXR       0                                            *
      *       REXI       *BLANKS                                      *
      *       PSCY       *BLANKS                                      *
      *       PEXR       0                                            *
      *       PEXI       *BLANKS                                      *
      *                                                               *
      *  File = LOAMSDK                                               *
      *                                                               *
      *       Field      Default Value                                *
      *       REXR       0                                            *
      *       REXI       *BLANKS                                      *
      *       PSCY       *BLANKS                                      *
      *       PEXR       0                                            *
      *       PEXI       *BLANKS                                      *
      *                                                               *
      *  File = LEPARTPD                                              *
      *                                                               *
      *       Field      Default Value                                *
      *       REXR       0                                            *
      *       REXI       *BLANKS                                      *
      *       PSCY       *BLANKS                                      *
      *       PEXR       0                                            *
      *       PEXI       *BLANKS                                      *
      *                                                               *
      *  File = CLOANCL                                               *
      *                                                               *
      *       Field      Default Value                                *
      *       REXR       0                                            *
      *       REXI       *BLANKS                                      *
      *       PSCY       *BLANKS                                      *
      *       PEXR       0                                            *
      *       PEXI       *BLANKS                                      *
      *       FPAM       0                                            *
      *                                                               *
      *  File = CLOANCK                                               *
      *                                                               *
      *       Field      Default Value                                *
      *       RRSR       0                                            *
      *       RRSI       *BLANKS                                      *
      *       RPSR       0                                            *
      *       RPSI       *BLANKS                                      *
      *                                                               *
      *  File = LEFEED                                                *
      *                                                               *
      *       Field      Default Value                                *
      *       FEREXR     0                                            *
      *       FEREXI     *BLANKS                                      *
      *       FEPSCY     *BLANKS                                      *
      *       FEPEXR     0                                            *
      *       FEPEXI     *BLANKS                                      *
      *                                                               *
      *  File = LEFEEAD                                               *
      *                                                               *
      *       Field      Default Value                                *
      *       FAREXR     0                                            *
      *       FAREXI     *BLANKS                                      *
      *       FAPSCY     *BLANKS                                      *
      *       FAPEXR     0                                            *
      *       FAPEXI     *BLANKS                                      *
      *                                                               *
      *  File = MCLONCL                                               *
      *                                                               *
      *       Field      Default Value                                *
      *       REXR       0                                            *
      *       REXI       *BLANKS                                      *
      *       PSCY       *BLANKS                                      *
      *       PEXR       0                                            *
      *       PEXI       *BLANKS                                      *
      *       FPAM       0                                            *
      *                                                               *
      *  File = MCLONCK                                               *
      *                                                               *
      *       Field      Default Value                                *
      *       RRSR       0                                            *
      *       RRSI       *BLANKS                                      *
      *       RPSR       0                                            *
      *       RPSI       *BLANKS                                      *
      *                                                               *
      *  Component of: LEC0031                                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031  *CREATE    Date 25Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CLE031 - Head Office Lending Enhancements                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FFCLTYFM   UF   E             DISK    INFSR(*PSSR)
      ** Midas LE Facilities detail

     FLOAMSDK   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(LA)
      ** Midas LE Loan amendments file

     FLEPARTPD  UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(LP)
      ** Midas LE Participant details file

     FCLOANCL   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(CL)
      ** Midas LE Customer loans details

     FCLOANCK   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(CK)
      ** Midas LE Customer loans details 2

     FLEFEED    UF   E             DISK    INFSR(*PSSR)
      ** Midas LE Fees Master details

     FLEFEEAD   UF   E             DISK    INFSR(*PSSR)
      ** Midas LE Fees settlement/adjustment details

     FMCLONCL   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(ML)
     F                                     RENAME(CLOANCLF:MCLONCLF)
      ** Midas LE New Matured Loans details

     FMCLONCK   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(MK)
     F                                     RENAME(CLOANCKF:MCLONCKF)
      ** Midas LE New Matured Loans details 2

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PMode           S              1
     D WRun            S              1

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   IF        PMODE = '1' OR PMODE = '3'
      ** Initialize fields for PF/FCLTYFM
     C                   READ      FCLTYFM

     C                   DOW       NOT %EOF(FCLTYFM)
     C                   EVAL      COAG = 'N'
     C                   EVAL      FCAG = 'N'
     C                   EVAL      PHAG = 'N'
     C                   EVAL      SCAG = 'N'
     C                   EVAL      REXR = *ZEROS
     C                   EVAL      REXI = *BLANKS
     C                   EVAL      PSCY = *BLANKS
     C                   EVAL      PEXR = *ZEROS
     C                   EVAL      PEXI = *BLANKS

     C                   UPDATE    FCLTYFMF

     C                   READ      FCLTYFM

     C                   ENDDO

      ** Initialize fields for PF/LOAMSDK
     C                   READ      LOAMSDK

     C                   DOW       NOT %EOF(LOAMSDK)
     C                   EVAL      LAREXR = *ZEROS
     C                   EVAL      LAREXI = *BLANKS
     C                   EVAL      LAPSCY = *BLANKS
     C                   EVAL      LAPEXR = *ZEROS
     C                   EVAL      LAPEXI = *BLANKS

     C                   UPDATE    LOAMSDKF

     C                   READ      LOAMSDK

     C                   ENDDO

      ** Initialize fields for PF/LEPARTPD
     C                   READ      LEPARTPD

     C                   DOW       NOT %EOF(LEPARTPD)
     C                   EVAL      LPREXR = *ZEROS
     C                   EVAL      LPREXI = *BLANKS
     C                   EVAL      LPPSCY = *BLANKS
     C                   EVAL      LPPEXR = *ZEROS
     C                   EVAL      LPPEXI = *BLANKS

     C                   UPDATE    LEPARTD0

     C                   READ      LEPARTPD

     C                   ENDDO

      ** Initialize fields for PF/CLOANCL
     C                   READ      CLOANCL

     C                   DOW       NOT %EOF(CLOANCL)
     C                   EVAL      CLREXR = *ZEROS
     C                   EVAL      CLREXI = *BLANKS
     C                   EVAL      CLPSCY = *BLANKS
     C                   EVAL      CLPEXR = *ZEROS
     C                   EVAL      CLPEXI = *BLANKS
     C                   EVAL      CLFPAM = *ZEROS

     C                   UPDATE    CLOANCLF

     C                   READ      CLOANCL

     C                   ENDDO

      ** Initialize fields for PF/CLOANCK
     C                   READ      CLOANCK

     C                   DOW       NOT %EOF(CLOANCK)
     C                   EVAL      CKRRSR = *ZEROS
     C                   EVAL      CKRRSI = *BLANKS
     C                   EVAL      CKRPSR = *ZEROS
     C                   EVAL      CKRPSI = *BLANKS

     C                   UPDATE    CLOANCKF

     C                   READ      CLOANCK

     C                   ENDDO

      ** Initialize fields for PF/LEFEED
     C                   READ      LEFEED

     C                   DOW       NOT %EOF(LEFEED)
     C                   EVAL      FEREXR = *ZEROS
     C                   EVAL      FEREXI = *BLANKS
     C                   EVAL      FEPSCY = *BLANKS
     C                   EVAL      FEPEXR = *ZEROS
     C                   EVAL      FEPEXI = *BLANKS

     C                   UPDATE    LEFEEDF

     C                   READ      LEFEED

     C                   ENDDO

      ** Initialize fields for PF/LEFEEAD
     C                   READ      LEFEEAD

     C                   DOW       NOT %EOF(LEFEEAD)
     C                   EVAL      FAREXR = *ZEROS
     C                   EVAL      FAREXI = *BLANKS
     C                   EVAL      FAPSCY = *BLANKS
     C                   EVAL      FAPEXR = *ZEROS
     C                   EVAL      FAPEXI = *BLANKS

     C                   UPDATE    LEFEEADF

     C                   READ      LEFEEAD

     C                   ENDDO

      ** Initialize fields for PF/MCLONCL
     C                   READ      MCLONCL

     C                   DOW       NOT %EOF(MCLONCL)
     C                   EVAL      MLREXR = *ZEROS
     C                   EVAL      MLREXI = *BLANKS
     C                   EVAL      MLPSCY = *BLANKS
     C                   EVAL      MLPEXR = *ZEROS
     C                   EVAL      MLPEXI = *BLANKS
     C                   EVAL      MLFPAM = *ZEROS

     C                   UPDATE    MCLONCLF

     C                   READ      MCLONCL

     C                   ENDDO

      ** Initialize fields for PF/MCLONCK
     C                   READ      MCLONCK

     C                   DOW       NOT %EOF(MCLONCK)
     C                   EVAL      MKRRSR = *ZEROS
     C                   EVAL      MKRRSI = *BLANKS
     C                   EVAL      MKRPSR = *ZEROS
     C                   EVAL      MKRPSI = *BLANKS

     C                   UPDATE    MCLONCKF

     C                   READ      MCLONCK

     C                   ENDDO

      ** ELSE PMODE = '2'
     C                   ELSE

      ** Initialize fields for PF/FCLTYFM
     C                   READ      FCLTYFM

     C                   DOW       NOT %EOF(FCLTYFM)

     C                   IF        COAG = *BLANKS
     C                   EVAL      COAG = 'N'
     C                   ENDIF

     C                   IF        FCAG = *BLANKS
     C                   EVAL      FCAG = 'N'
     C                   ENDIF

     C                   IF        PHAG = *BLANKS
     C                   EVAL      PHAG = 'N'
     C                   ENDIF

     C                   IF        SCAG = *BLANKS
     C                   EVAL      SCAG = 'N'
     C                   ENDIF

     C                   IF        REXR = *ZEROS
     C                   EVAL      REXR = *ZEROS
     C                   EVAL      REXI = *BLANKS
     C                   ENDIF

     C                   IF        PSCY = *BLANKS
     C                   EVAL      PSCY = *BLANKS
     C                   ENDIF

     C                   IF        PEXR = *ZEROS
     C                   EVAL      PEXR = *ZEROS
     C                   EVAL      PEXI = *BLANKS
     C                   ENDIF

     C                   UPDATE    FCLTYFMF

     C                   READ      FCLTYFM

     C                   ENDDO

      ** Initialize fields for PF/LOAMSDK
     C                   READ      LOAMSDK

     C                   DOW       NOT %EOF(LOAMSDK)

     C                   IF        LAREXR = *ZEROS
     C                   EVAL      LAREXR = *ZEROS
     C                   EVAL      LAREXI = *BLANKS
     C                   ENDIF

     C                   IF        LAPSCY = *BLANKS
     C                   EVAL      LAPSCY = *BLANKS
     C                   ENDIF

     C                   IF        LAPEXR = *ZEROS
     C                   EVAL      LAPEXR = *ZEROS
     C                   EVAL      LAPEXI = *BLANKS
     C                   ENDIF

     C                   UPDATE    LOAMSDKF

     C                   READ      LOAMSDK

     C                   ENDDO

      ** Initialize fields for PF/LEPARTPD
     C                   READ      LEPARTPD

     C                   DOW       NOT %EOF(LEPARTPD)

     C                   IF        LPREXR = *ZEROS
     C                   EVAL      LPREXR = *ZEROS
     C                   EVAL      LPREXI = *BLANKS
     C                   ENDIF

     C                   IF        LPPSCY = *BLANKS
     C                   EVAL      LPPSCY = *BLANKS
     C                   ENDIF

     C                   IF        LPPEXR = *ZEROS
     C                   EVAL      LPPEXR = *ZEROS
     C                   EVAL      LPPEXI = *BLANKS
     C                   ENDIF

     C                   UPDATE    LEPARTD0

     C                   READ      LEPARTPD

     C                   ENDDO

      ** Initialize fields for PF/CLOANCL
     C                   READ      CLOANCL

     C                   DOW       NOT %EOF(CLOANCL)

     C                   IF        CLREXR = *ZEROS
     C                   EVAL      CLREXR = *ZEROS
     C                   EVAL      CLREXI = *BLANKS
     C                   ENDIF

     C                   IF        CLPSCY = *BLANKS
     C                   EVAL      CLPSCY = *BLANKS
     C                   ENDIF

     C                   IF        CLPEXR = *ZEROS
     C                   EVAL      CLPEXR = *ZEROS
     C                   EVAL      CLPEXI = *BLANKS
     C                   ENDIF

     C                   IF        CLFPAM = *ZEROS
     C                   EVAL      CLFPAM = *ZEROS
     C                   ENDIF

     C                   UPDATE    CLOANCLF

     C                   READ      CLOANCL

     C                   ENDDO

      ** Initialize fields for PF/CLOANCK
     C                   READ      CLOANCK

     C                   DOW       NOT %EOF(CLOANCK)

     C                   IF        CKRRSR = *ZEROS
     C                   EVAL      CKRRSR = *ZEROS
     C                   EVAL      CKRRSI = *BLANKS
     C                   ENDIF

     C                   IF        CKRPSR = *ZEROS
     C                   EVAL      CKRPSR = *ZEROS
     C                   EVAL      CKRPSI = *BLANKS
     C                   ENDIF

     C                   UPDATE    CLOANCKF

     C                   READ      CLOANCK

     C                   ENDDO

      ** Initialize fields for PF/LEFEED
     C                   READ      LEFEED

     C                   DOW       NOT %EOF(LEFEED)

     C                   IF        FEREXR = *ZEROS
     C                   EVAL      FEREXR = *ZEROS
     C                   EVAL      FEREXI = *BLANKS
     C                   ENDIF

     C                   IF        FEPSCY = *BLANKS
     C                   EVAL      FEPSCY = *BLANKS
     C                   ENDIF

     C                   IF        FEPEXR = *ZEROS
     C                   EVAL      FEPEXR = *ZEROS
     C                   EVAL      FEPEXI = *BLANKS
     C                   ENDIF

     C                   UPDATE    LEFEEDF

     C                   READ      LEFEED

     C                   ENDDO

      ** Initialize fields for PF/LEFEEAD
     C                   READ      LEFEEAD

     C                   DOW       NOT %EOF(LEFEEAD)

     C                   IF        FAREXR = *ZEROS
     C                   EVAL      FAREXR = *ZEROS
     C                   EVAL      FAREXI = *BLANKS
     C                   ENDIF

     C                   IF        FAPSCY = *BLANKS
     C                   EVAL      FAPSCY = *BLANKS
     C                   ENDIF

     C                   IF        FAPEXR = *ZEROS
     C                   EVAL      FAPEXR = *ZEROS
     C                   EVAL      FAPEXI = *BLANKS
     C                   ENDIF

     C                   UPDATE    LEFEEADF

     C                   READ      LEFEEAD

     C                   ENDDO

      ** Initialize fields for PF/MCLONCL
     C                   READ      MCLONCL

     C                   DOW       NOT %EOF(MCLONCL)

     C                   IF        MLREXR = *ZEROS
     C                   EVAL      MLREXR = *ZEROS
     C                   EVAL      MLREXI = *BLANKS
     C                   ENDIF

     C                   IF        MLPSCY = *BLANKS
     C                   EVAL      MLPSCY = *BLANKS
     C                   ENDIF

     C                   IF        MLPEXR = *ZEROS
     C                   EVAL      MLPEXR = *ZEROS
     C                   EVAL      MLPEXI = *BLANKS
     C                   ENDIF

     C                   IF        MLFPAM = *ZEROS
     C                   EVAL      MLFPAM = *ZEROS
     C                   ENDIF

     C                   UPDATE    MCLONCLF

     C                   READ      MCLONCL

     C                   ENDDO

      ** Initialize fields for PF/MCLONCK
     C                   READ      MCLONCK

     C                   DOW       NOT %EOF(MCLONCK)

     C                   IF        MKRRSR = *ZEROS
     C                   EVAL      MKRRSR = *ZEROS
     C                   EVAL      MKRRSI = *BLANKS
     C                   ENDIF

     C                   IF        MKRPSR = *ZEROS
     C                   EVAL      MKRPSR = *ZEROS
     C                   EVAL      MKRPSI = *BLANKS
     C                   ENDIF

     C                   UPDATE    MCLONCKF

     C                   READ      MCLONCK

     C                   ENDDO

     C                   ENDIF

     C                   EVAL      *INLR = *ON

      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************

     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
