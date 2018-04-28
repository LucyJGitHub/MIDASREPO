     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Take-on Program')                                      *
      *****************************************************************
      *                                                               *
      *  Midas - Fund Transfer Module                                 *
      *                                                               *
      *  FT0000032 - Take-on Program                                  *
      *                                                               *
      *  This program will run when the feature is implemented.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CAP205             Date 23Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14042           Date 24May07               *
      *                 BUG14939           Date 03Oct07               *
      *                 BUG13798           Date 24Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032  *CREATE    Date 11Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  BUG14042 - CFT032 errors ; applied fix 13798                 *
      *  BUG14939 - Calls ME1743 instead of ME001743                  *
      *  BUG13798 - CFT032 errors                                     *
      *  CFT032   - Fund Transfer                                     *
      *                                                               *
      *****************************************************************
      *
      ** Midas FT Outgoing payments details
      *
     FOTPAY     UF   E           K DISK    INFSR(*PSSR) USROPN
      *
      ** Midas ME Outgoing Message Field Management
      *
     FMEOUFML0  UF A E           K DISK    INFSR(*PSSR) USROPN
      *
      ** Midas SD Midas system values
      *
     FSDSVALL0  UF A E           K DISK    INFSR(*PSSR) USROPN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      * U7+U8 - Database Error                                        *
      * 40 - Toggle between Flat and Percentage Matching Tolerance    *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR   - Program Initialisation                            *
      *  SROTPAY  - Update ODMT and ODMTT fields.                     *
      *  SRMEOUFM - Update MEOUFMPD file.                             *
      *  SRSDSVAL - Update SDSVALPD file.                             *
      *  SRME1752 - Call ME1752 promgram.                             *
      *  SRME1743 - Call ME1743 promgram.                             *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
     D/EJECT
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Array containing Copyright statement
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D PSDS           SDS
 
      ** Program Status Data Structure
 
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
      ** Rundate data area
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structures for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - short data structure
 
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
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
     D WRunD           S              5  0
     D PGISVAL         S             20
 
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Update OTPAYDD file
 
     C                   EXSR      SROTPAY
 
      ** Update MEOUFMPD file
 
     C                   EXSR      SRMEOUFM
 
      ** Update SDSVALPD file
 
     C                   EXSR      SRSDSVAL
 
      ** Call ME1752
 
     C                   EXSR      SRME1752
 
      ** Call ME1743
 
     C                   EXSR      SRME1743
 
 
     C                   RETURN
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
 
      *****************************************************************
      /TITLE SR/SROTPAY
      *****************************************************************
      *                                                               *
      *  SROTPAY - Update OTPAYDD file.                               *
      *                                                               *
      *****************************************************************
 
     C     SROTPAY       BEGSR
 
     C                   OPEN      OTPAY
 
     C     *LOVAL        SETLL     OTPAY
     C                   READ      OTPAY
     C                   DOW       NOT %EOF(OTPAY)
     C                   EVAL      ODMT  = ODMTO
     C                   IF        ODMT <> *BLANKS
     C                   EVAL      ODMTT = 'C'
     C                   ENDIF
     C                   UPDATE    OTPAYDDF
     C                   READ      OTPAY
     C                   ENDDO
 
     C                   CLOSE     OTPAY
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SRMEOUFM
      *****************************************************************
      *                                                               *
      *  SRMEOUFM - Subroutine to do the Detail Processing            *
      *                                                               *
      *****************************************************************
 
     C     SRMEOUFM      BEGSR
 
     C                   OPEN      MEOUFML0
 
     C                   EVAL      POMNWRK   = 'SWIFT'
     C                   EVAL      POMMTPY   = '103'
     C                   EVAL      POMMTAG   = ':50K:'
     C                   EVAL      POMSBRC   = *BLANKS
     C                   EVAL      POMCTRY   = *BLANKS
     C                   EVAL      POMCURR   = *BLANKS
     C                   EVAL      POMNOST   = *BLANKS
     C                   EVAL      POMACTI   = 'ACOUNTLINE'
 
     C     @PMEOUFM      CHAIN     MEOUFML0
     C                   IF        NOT %FOUND(MEOUFML0)
     C                   EVAL      OMNWRK   = POMNWRK
     C                   EVAL      OMMTPY   = POMMTPY
     C                   EVAL      OMMTAG   = POMMTAG
     C                   EVAL      OMSBRC   = POMSBRC
     C                   EVAL      OMCTRY   = POMCTRY
     C                   EVAL      OMCURR   = POMCURR
     C                   EVAL      OMNOST   = POMNOST
     C                   EVAL      OMACTI   = POMACTI
     C                   EVAL      OMFLAG   = 'O'
     C                   WRITE     @OUFMPD
     C                   ENDIF
 
     C                   EVAL      POMMTAG   = ':50A:'
 
     C     @PMEOUFM      CHAIN     MEOUFML0
     C                   IF        NOT %FOUND(MEOUFML0)
     C                   EVAL      OMNWRK   = POMNWRK
     C                   EVAL      OMMTPY   = POMMTPY
     C                   EVAL      OMMTAG   = POMMTAG
     C                   EVAL      OMSBRC   = POMSBRC
     C                   EVAL      OMCTRY   = POMCTRY
     C                   EVAL      OMCURR   = POMCURR
     C                   EVAL      OMNOST   = POMNOST
     C                   EVAL      OMACTI   = POMACTI
     C                   EVAL      OMFLAG   = 'O'
     C                   WRITE     @OUFMPD
     C                   ENDIF
 
     C                   EVAL      POMMTAG   = ':59:'
 
     C     @PMEOUFM      CHAIN     MEOUFML0
     C                   IF        NOT %FOUND(MEOUFML0)
     C                   EVAL      OMNWRK   = POMNWRK
     C                   EVAL      OMMTPY   = POMMTPY
     C                   EVAL      OMMTAG   = POMMTAG
     C                   EVAL      OMSBRC   = POMSBRC
     C                   EVAL      OMCTRY   = POMCTRY
     C                   EVAL      OMCURR   = POMCURR
     C                   EVAL      OMNOST   = POMNOST
     C                   EVAL      OMACTI   = POMACTI
     C                   EVAL      OMFLAG   = 'O'
     C                   WRITE     @OUFMPD
     C                   ENDIF
 
     C                   EVAL      POMMTAG   = ':59A:'
 
     C     @PMEOUFM      CHAIN     MEOUFML0
     C                   IF        NOT %FOUND(MEOUFML0)
     C                   EVAL      OMNWRK   = POMNWRK
     C                   EVAL      OMMTPY   = POMMTPY
     C                   EVAL      OMMTAG   = POMMTAG
     C                   EVAL      OMSBRC   = POMSBRC
     C                   EVAL      OMCTRY   = POMCTRY
     C                   EVAL      OMCURR   = POMCURR
     C                   EVAL      OMNOST   = POMNOST
     C                   EVAL      OMACTI   = POMACTI
     C                   EVAL      OMFLAG   = 'O'
     C                   WRITE     @OUFMPD
     C                   ENDIF
 
     C                   EVAL      POMMTAG   = ':50K:'
     C                   EVAL      POMACTI   = 'ACOUNTIBAN'
 
     C     @PMEOUFM      CHAIN     MEOUFML0
     C                   IF        NOT %FOUND(MEOUFML0)
     C                   EVAL      OMNWRK   = POMNWRK
     C                   EVAL      OMMTPY   = POMMTPY
     C                   EVAL      OMMTAG   = POMMTAG
     C                   EVAL      OMSBRC   = POMSBRC
     C                   EVAL      OMCTRY   = POMCTRY
     C                   EVAL      OMCURR   = POMCURR
     C                   EVAL      OMNOST   = POMNOST
     C                   EVAL      OMACTI   = POMACTI
     C                   EVAL      OMFLAG   = 'O'
     C                   WRITE     @OUFMPD
     C                   ENDIF
 
     C                   EVAL      POMMTAG   = ':50A:'
 
     C     @PMEOUFM      CHAIN     MEOUFML0
     C                   IF        NOT %FOUND(MEOUFML0)
     C                   EVAL      OMNWRK   = POMNWRK
     C                   EVAL      OMMTPY   = POMMTPY
     C                   EVAL      OMMTAG   = POMMTAG
     C                   EVAL      OMSBRC   = POMSBRC
     C                   EVAL      OMCTRY   = POMCTRY
     C                   EVAL      OMCURR   = POMCURR
     C                   EVAL      OMNOST   = POMNOST
     C                   EVAL      OMACTI   = POMACTI
     C                   EVAL      OMFLAG   = 'O'
     C                   WRITE     @OUFMPD
     C                   ENDIF
 
     C                   EVAL      POMMTAG   = ':59:'
 
     C     @PMEOUFM      CHAIN     MEOUFML0
     C                   IF        NOT %FOUND(MEOUFML0)
     C                   EVAL      OMNWRK   = POMNWRK
     C                   EVAL      OMMTPY   = POMMTPY
     C                   EVAL      OMMTAG   = POMMTAG
     C                   EVAL      OMSBRC   = POMSBRC
     C                   EVAL      OMCTRY   = POMCTRY
     C                   EVAL      OMCURR   = POMCURR
     C                   EVAL      OMNOST   = POMNOST
     C                   EVAL      OMACTI   = POMACTI
     C                   EVAL      OMFLAG   = 'O'
     C                   WRITE     @OUFMPD
     C                   ENDIF
 
     C                   EVAL      POMMTAG   = ':59A:'
 
     C     @PMEOUFM      CHAIN     MEOUFML0
     C                   IF        NOT %FOUND(MEOUFML0)
     C                   EVAL      OMNWRK   = POMNWRK
     C                   EVAL      OMMTPY   = POMMTPY
     C                   EVAL      OMMTAG   = POMMTAG
     C                   EVAL      OMSBRC   = POMSBRC
     C                   EVAL      OMCTRY   = POMCTRY
     C                   EVAL      OMCURR   = POMCURR
     C                   EVAL      OMNOST   = POMNOST
     C                   EVAL      OMACTI   = POMACTI
     C                   EVAL      OMFLAG   = 'O'
     C                   WRITE     @OUFMPD
     C                   ENDIF
 
     C                   CLOSE     MEOUFML0
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SRSDSVAL
      *****************************************************************
      *                                                               *
      *  SRSDSVAL - Subroutine to do the Detail Processing            *
      *                                                               *
      *****************************************************************
 
     C     SRSDSVAL      BEGSR
 
     C                   OPEN      SDSVALL0
 
     C                   EVAL      PGISVAL   = 'AllowMT103AccFATF'
 
     C     PGISVAL       CHAIN     SDSVALL0
     C                   IF        NOT %FOUND(SDSVALL0)
     C                   EVAL      GISVAL   = PGISVAL
     C                   EVAL      GIMMOD   = 'FT'
     C                   EVAL      GIMMSN   = 'FUNDSTRAN'
     C                   EVAL      GIDESC   = 'Allow MT103 Account input for FA-
     C                             TF Transaction'
     C                   EVAL      GIVAL    = 'N'
     C                   EVAL      GIDFT    = 'N'
     C                   EVAL      GIHELP   = 'Y,N'
     C                   EVAL      GIDLEN   = '1'
     C                   EVAL      GISWCH   = 'CFT032'
     C                   EVAL      GIALWB   = *BLANKS
     C                   EVAL      GIEMSG   = 'USRxxxx'
     C                   EVAL      GILCD    = WRunD
     C                   EVAL      GILCT    = 'I'
     C                   WRITE     @SVALL0
     C                   ENDIF
 
     C                   CLOSE     SDSVALL0
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SRME1752
      *****************************************************************
      *                                                               *
      *  SRME1752 - Subroutine to do the Detail Processing            *
      *                                                               *
      *****************************************************************
 
     C     SRME1752      BEGSR
 
     C                   CALL      'FC0040X'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      'ME1742'      PREPNAME         10
     C                   PARM      'MEC1742'     PREPCOMP         10
     C                   PARM      '1000'        PREPSEQ           5
     C                   PARM      *BLANKS       PADDPAR         100
     C                   PARM      'Y'           PMULTBIN          1
     C                   PARM      'S'           PLEVEL            1
     C                   PARM      *BLANKS       PENTITY           3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SRME1743
      *****************************************************************
      *                                                               *
      *  SRME1743 - Subroutine to do the Detail Processing            *
      *                                                               *
      *****************************************************************
 
     C     SRME1743      BEGSR
 
     C**********         CALL      'ME1743'                                                 BUG14939
     C                   CALL      'ME001743'                                               BUG14939
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameter list
 
     C     @PMEOUFM      KLIST
     C                   KFLD                    POMNWRK           6
     C                   KFLD                    POMMTPY           3
     C                   KFLD                    POMMTAG           5
     C**********         KFLD                    POMSBRC           3                        BUG13798
     C                   KFLD                    POMSBRC           4                        BUG13798
     C**********         KFLD                    POMCTRY           2                        BUG13798
     C                   KFLD                    POMCTRY           4                        BUG13798
     C                   KFLD                    POMCURR           3
     C                   KFLD                    POMNOST           2
     C                   KFLD                    POMACTI          10
 
      ** Initialise LDA field
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBMOD = *BLANKS
     C                   EVAL      DBPGM = 'FT0000032'
     C                   EVAL      DBPROC    =   *BLANKS
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = PRTCD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WRunD = BJRDNB
 
      ** Initialise report work fields
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
** CPY@
(c) Misy  s International Banking Systems Ltd. 2006
