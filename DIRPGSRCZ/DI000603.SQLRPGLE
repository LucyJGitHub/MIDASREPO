     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas OF Accounting Rules Files Retention Process')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL000603*-*Midas*OF*Accounting*Rules*Files*Retention**********                     MD029739
      *  DI000603 - Midas OF Accounting Rules Files Retention         *                     MD029739
      *             Processing                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029739 *RENAMED* Date 15Aug14               *
      *  Prev Amend No. MD024772           Date 03Feb14               *
      *                 MD024513           Date 23Jan14               *
      *                 MD024461           Date 22Jan14               *
      *                 MD023886 *CREATE   Date 29Nov13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029739 - File renaming for integration layer.              *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries. (Recompile)                            *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  MD024461 - Wrong name of pgm called to drop DTAARA BatchId   *
      *  MD023886 - Retention of files of posting amounts/accounting  *
      *             events injected into Accounting Rule              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     ** File DS
     **   Midas GL Accounting Rules Monitor File
     D*ACMN*****     E DS                  EXTNAME(GLACMNTD)                                MD029739
     D ACMN          E DS                  EXTNAME(DIACMNTD)                                MD029739
     D*ACME*****     E DS                  EXTNAME(IGACMETD)                                MD029739
     D ACME          E DS                  EXTNAME(DIACMETD)                                MD029739
 
      ** Data structure for AOSVALR0 string
     D @SVAL1          DS           200
     D  SVAL1                  1    200
     D  SVAL1_1                1      3S 0
 
     D WDateVar        DS
     D  WDateOut               1      8  0
     D   WYR                   1      4
     D   WMM                   5      6
     D   WDD                   7      8
 
     D WTmeStmp        DS            26
     D   W2YR                  1      4
     D   W2XX1                 5      5
     D   W2MM                  6      7
     D   W2XX2                 8      8
     D   W2DD                  9     10
     D   W2REST               11     26
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
 
     D WRun            S              1A   Inz
     D WTimeStmp       S             26A
 
      ** Parameter variables for AOSVALR0 string
     D RTNCDE          S              7
     D SVALK1          S            200
     D SVALK2          S             20
     D SVAL2           S            200
     D SVALK3          S             20
     D SVAL3           S            200
     D SVALK4          S             20
     D SVAL4           S            200
     D SVALK5          S             20
     D SVAL5           S            200
     D SVALK6          S             20
     D SVAL6           S            200
     D SVALK7          S             20
     D SVAL7           S            200
     D SVALK8          S             20
     D SVAL8           S            200
     D SVALK9          S             20
     D SVAL9           S            200
     D SVALK0          S             20
     D SVAL10          S            200
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Drop of Accounting Rules Interface file
 
     C                   EXSR      SRAcctInt
 
      ** Drop of Accounting Rules files
 
     C                   EXSR      SRAccntRule
 
      ** Drop of Meridian Intellimatch RAW data
 
     C                   EXSR      SRMeridian
 
      ** Drop of Meridian File Rejected
 
     C                   EXSR      SRMerReject
 
      ** End Program
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcctInt - Accounting Rules Interface file drop             *
      *                                                               *
      *****************************************************************
     C     SRAcctInt     BEGSR
 
     C/EXEC SQL
     C+ DELETE from DIACIFTD
     C+ where IFCRTD < :WRetDate
     C/END-EXEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccntRule - Accounting Rules files drop                    *
      *                                                               *
      *****************************************************************
     C     SRAccntRule   BEGSR
 
      ** Set file pointer to first record and do initial read
 
     C/exec SQL
     C+ declare LIST cursor for
     C*+select** from GLACMNTD                                                              MD029739
     C+ select * from DIACMNTD                                                              MD029739
     C+ where MNRNDN < :WRetDate
     C+ order by
     C+       MNBTID,
     C+       MNFRNT
     C/end-exec
 
     C/exec SQL
     C+ open LIST
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCOD < 0
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
     C/exec SQL
     C+ fetch next
     C+ from LIST
     C+ into: ACMN
     C/end-exec
 
      ** Read Accounting Rules Batch Details until end of file
 
     C                   DOW       SQLCode <> 100
 
     C/EXEC SQL
     C*+DELETE*from GLACMNTD                                                                MD029739
     C+ DELETE from DIACMNTD                                                                MD029739
     C+ where MNBTID = :MNBTID
     C/END-EXEC
 
     C/EXEC SQL
     C*+DELETE*from GLACBDTD                                                                MD029739
     C+ DELETE from DIACBDTD                                                                MD029739
     C+ where BDBTID = :MNBTID
     C/END-EXEC
 
     C/EXEC SQL
     C*+DELETE*from GLACBHTD                                                                MD029739
     C+ DELETE from DIACBHTD                                                                MD029739
     C+ where BHBTID = :MNBTID
     C/END-EXEC
 
     C                   EVAL      WBATCH = 'A' + %SUBST(MNBTID:7:9)
     C**********         CALL      'GLC000595'                                              MD024461
     C                   CALL      'GLC000601'                                              MD024461
     C                   PARM                    WBATCH           10
 
     C/exec SQL
     C+ fetch next from LIST
     C+ into :ACMN
     C/end-exec
 
     C                   ENDDO
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCode < 100
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
     C/exec SQL
     C+ close LIST
     C/end-exec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMeridian - Meridian Intellimatch RAW data drop             *
      *                                                               *
      *****************************************************************
     C     SRMeridian    BEGSR
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    WRetDate
     C                   PARM                    WDateOut          8 0
     C                   PARM                    WRtrn             1
 
     C                   EVAL      W2XX1 = '-'
     C                   EVAL      W2XX2 = '-'
     C                   EVAL      W2YR  = WYR
     C                   EVAL      W2MM  = WMM
     C                   EVAL      W2DD  = WDD
     C                   EVAL      W2REST = *BLANKS
     C                   EVAL      WTimeStmp = WTmeStmp
 
     C/EXEC SQL
     C*+DELETE*from IGACMETD                                                                MD029739
     C+ DELETE from DIACMETD                                                                MD029739
     C+ where XFTMSP < :WTimeStmp
     C/END-EXEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMerReject - Meridian File Rejected                         *
      *                                                               *
      *****************************************************************
     C     SRMerReject   BEGSR
 
 
     C/EXEC SQL
     C*+DELETE*from IGACMRTD                                                                MD029739
     C+ DELETE from DIACMRTD                                                                MD029739
     C+ where XFTMSP < :WTimeStmp
     C/END-EXEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Set off program indicators
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Access Bank details
      **   Retrieve Run day number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Retrieve the system value
 
     C                   EVAL      SVALK1 = 'AcctRulesRetention'
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE
     C                   PARM                    SVALK1
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10
 
      ** If the system value is not found then issue a database error
 
     C     RTNCDE        IFNE      '       '
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     BJRDNB        SUB       SVAL1_1       WRetDAte          5 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      PRTCD = '*ERROR'
 
     C                   RETURN
 
     C                   ENDSR
