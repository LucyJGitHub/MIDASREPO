     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Automatic Account Closure')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0083 - Midas GL Automatic Account Closure                  *
      *                                                               *
      *  Program Function: This program will close General Ledger     *
      *                    Accounts which have not moved since the    *
      *                    pre-defined in-activity period and have    *
      *                    a balance of zero. Details of Accounts     *
      *                    closed will be output to a report.         *
      *                                                               *
      *  Phase(s): COB - Automatic.                                   *
      *                                                               *
      *  Called By: GLC0083 - Midas GL Automatic Account Closure      *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD012161           Date 18Aug23               *
      *  Prev Amend No. AR1065986          Date 18Aug23               *
      *                 AR928468           Date 18Aug23               *
      *                 CGL083 *Create     Date 18Aug23               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD012161 - GLC0083 in MSGW due to printer overflow. Add      *
      *             standard creation paramater in GL0083P1.          *
      *  AR1065986 - Include account types 'D' and 'C' and include    *
      *              condition that only non-SWIFT accounts will be   *
      *              dropped. (Child:  AR1065987)                     *
      *  AR928468 - MEC105 failed due to deleted accounts still used  *
      *             as SWIFT reference. Only close account if it is   *
      *             not linked to Live Swift or Nostro account.       *
      *             (Child: AR928469)                                 *
      *  CGL083 - Automatic Account Closure                           *
      *                                                               *
      *****************************************************************
      *
     FSWACB     IF   E           K DISK    INFSR(*PSSR)                                     AR928468
     F                                     IGNORE(SWACSSAF)                                 AR928468
     F                                     RENAME(SWACSSBF:SWACSSBW)                        AR928468
     F                                     IGNORE(SWACSSCF)                                 AR928468
     FSDNOSTL2  IF   E           K DISK    INFSR(*PSSR)                                     AR928468
      ** SD Nostro details by full account number                                           AR928468
      *                                                                                     AR928468
     FACCBR     UF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Accounts by Branch
      *
     FACCNTAC   UF   E             DISK    INFSR(*PSSR)
      ** Midas GL Accounts Master Trailer
      *
     FSWACS     IF   E           K DISK    INFSR(*PSSR)                                    AR1065986
     F                                     IGNORE(SWACSSAF)                                AR1065986
     F                                     IGNORE(SWACSSCF)                                AR1065986
      ** Midas SWIFT Accounts Master                                                       AR1065986
      *                                                                                    AR1065986
     FGL0083P1  O    E             PRINTER
     F                                     INFDS(SPOOL1)
      ** Midas GL Automatic Account Closure Report
      *
     FGL0083AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** Midas GL Automatic Account Closure Audit
      *
      *****************************************************************
      *                                                               *
      *                    FUNCTION OF INDICATORS                     *
      *                    **********************                     *
      *                                                               *
      *   50  - No Record to Report                                   *
      *   80  - End of File ACCBR                                     *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *                      SUBROUTINE INDEX                         *
      *                      ****************                         *
      *                                                               *
      *  SRINIT   - Subroutine to do Program Initialisation.          *
      *  SRPROC   - Subroutine to do Detail Processing.               *
      *  SRCLAC   - Subroutine to Close General Ledger Account        *
      *  SRPRNT   - Subroutine to Print detail record.                *
      *  SREND    - Subroutine to Write End of Report.                *
      *  SRAUDT   - Subroutine to Output Audit report and End Program.*
      *  SRRCFA   - Subroutine to register GL0083AU via RCF.          *
      *  SRRCFP   - Subroutine to register GL0083P1 via RCF.          *
      *  SRTERM   - Subroutine to Terminate program                   *
      *  *PSSR    - Program exception error routine.                  *
      *                                                               *
      *  ZTNLU1   - To Retrieve the next Transaction Number           *
      *  ZDATE2   - To Format a Midas Number in Alpha Date            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      *
     D/EJECT
      *
      ** Array containing Copyright statement
      *
     D SVL             S             20    DIM(1) CTDATA PERRCD(1)
      *
      **  Short data structure for access programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure to receive Bank Details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** Data Structure to receive General Ledger Details
      *
      ***  File Information Data Structure for GL0083P1.
      *
     D SPOOL1          DS
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ***  File Information Data Structure for GL0083AU.
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      /COPY ZSRSRC,ZDATE2Z1LE
      *
      /COPY ZSRSRC,ZTNLU1Z3
      /SPACE 3
     ISWACSSBW                                                                              AR928468
      ** Rename RECI to prevent overwrite from pf/REIACD, RPG REIACXX                       AR928468
      *                                                                                     AR928468
     I              RECI                        RECISW                                      AR928468
     I              CNUMA                       CNUMSW                                      AR928468
     I              CCY                         CCYSW                                       AR928468
     I              ACODQQ                      ACDQSW                                      AR928468
     I              ACSQ                        ACSQSW                                      AR928468
     I              CFSB                        CFSBSW                                      AR928468
     I              LSTD                        LSTDSW                                      AR928468
     I              NSTD                        NSTDSW                                      AR928468
     I              ACNO                        ACNOSW                                      AR928468
     I              STFQ                        STFQSW                                      AR928468
     I              STDY                        STDYSW                                      AR928468
     I              LSNO                        LSNOSW                                      AR928468
     I              UPRI                        UPRISW                                      AR928468
     I              DDIS                        DDISSW                                      AR928468
     I              BRCA                        BRCASW                                      AR928468
     I              IND                         INDSW                                       AR928468
     I              ZZ006                       ZZ06SW                                      AR928468
     I              LCD                         LCDSW                                       AR928468
     I              CHTP                        CHTPSW                                      AR928468
     I              TNLU                        TNLUSW                                      AR928468
     I              MT94                        MT94SW                                      AR928468
     I              ACOD                        ACODSW                                      AR928468
      *                                                                                     AR928468
      ** Local data area for database error details
      *
     ISWACSSBF                                                                            AR10659861
     I              RECI                        SWRECI                                    AR10659861
     I              CNUMA                       SWCNUM                                    AR10659861
     I              CCY                         SWCCY                                     AR10659861
     I              ACODQQ                      SWACQD                                    AR10659861
     I              ACSQ                        SWACSQ                                    AR10659861
     I              CFSB                        SWCFSB                                    AR10659861
     I              LSTD                        SWLSTD                                    AR10659861
     I              NSTD                        SWNSTD                                    AR10659861
     I              ACNO                        SWACNO                                    AR10659861
     I              STFQ                        SWSTFQ                                    AR10659861
     I              STDY                        SWSTDY                                    AR10659861
     I              LSNO                        SWLSNO                                    AR10659861
     I              UPRI                        SWUPRI                                    AR10659861
     I              DDIS                        SWDDIS                                    AR10659861
     I              BRCA                        SWBRCA                                    AR10659861
     I              IND                         SWIND                                     AR10659861
     I              ZZ006                       SWZZ00                                    AR10659861
     I              LCD                         SWLCD                                     AR10659861
     I              CHTP                        SWCHTP                                    AR10659861
     I              TNLU                        SWTNLU                                    AR10659861
     I              MT94                        SWMT94                                    AR10659861
     I              ACOD                        SWACOD                                    AR10659861
      *
      *
     C/EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      **  Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      **  Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      **  Output Audit Report and End Program.
      *
     C                   EXSR      SRAUDT
      *
      **  Perform Termination Processing.
      *
     C                   EXSR      SRTERM
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      *
      *****************************************************************
      *  SRINIT   - Subroutine to do Program Initialisation.          *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:     AOBANKR0                                          *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      **  Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
      *                                                                                    AR1065986
      **  SWIFT accounts Key List                                                          AR1065986
      *                                                                                    AR1065986
     C     KSWAC         KLIST                                                             AR1065986
     C                   KFLD                    SWCNUM                                    AR1065986
     C                   KFLD                    SWCCY                                     AR1065986
     C                   KFLD                    SWACOD                                    AR1065986
     C                   KFLD                    SWACSQ                                    AR1065986
     C                   KFLD                    SWBRCA                                    AR1065986
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'GL0083'      DBPGM
      *
      ** Access Bank details via access program
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     ULRTCD            7
     C                   PARM      '*FIRST '     ULOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          *DB ERROR 01*
     C                   MOVEL     ULOPTN        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      *                            MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Get General Ledger Details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     ULRTCD            7
     C                   PARM      '*FIRST '     ULOPTN            7
     C     SDGELR        PARM      SDGELR        DSFDY
      *
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA                                          *************
     C                   Z-ADD     2             DBASE                          *DB ERROR 02*
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     ULOPTN        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF                                                  E1
      *
      *
      **  Access SAR details file to see if CGL083 SAR is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CGL083'      @KEY              6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL083            1
     C                   ELSE
     C                   MOVE      'N'           CGL083
     C                   ENDIF
      *
      *  Access System Value
     C                   CLEAR                   LINPD
     C     CGL083        IFEQ      'Y'
     C                   MOVEL     SVL(1)        SVALK1
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE            7
     C                   PARM                    SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVAL10           20
     C                   PARM                    SVAL11          200
      *
     C     RTNCDE        IFEQ      *BLANKS
     C                   MOVEL     SVAL1         FIELD4            4
     C                   MOVE      FIELD4        LINPD             4 0
     C                   ELSE
     C                   MOVE      'N'           CGL083
     C                   END
     C                   END
      *
      ** RCF Processing for Printer File
      *
     C                   EXSR      SRRCFP
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      SRRCFA
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
      ** Initialise all working fields
      *
     C                   Z-ADD     *ZERO         ULRCNT            4 0          No of Rejn Code
      *
      ** Write Report header and column headings
      *
     C                   WRITE     PGHEADER                                     Report header
     C                   WRITE     DTHEADER                                     Columns Header
      *
     C                   ENDSR
      *
      /TITLE SR/SRPROC
      *****************************************************************
      *  SRPROC   - Subroutine to do Detail Processing.               *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      ** Read Accounts file
      *
     C     *LOVAL        SETLL     ACCBR
     C                   READ      ACCBR                                  80
      *
     C     *IN80         DOWEQ     *OFF
      *
      ***Only*process*open*General*Ledger*Accounts*with*Balance*of*Zero                    AR1065986
      ** Only process open General Ledger, Dealing and Contingent accounts                 AR1065986
      **  with zero balance                                                                AR1065986
     C     LDBL          IFEQ      *ZERO                                                   AR1065986
     C     ACST          ANDNE     'C'                                                     AR1065986
      *                                                                                    AR1065986
     C     ATYP          IFEQ      'G'
     C     ATYP          OREQ      'D'                                                     AR1065986
     C     ATYP          OREQ      'C'                                                     AR1065986
     C*****LDBL          ANDEQ*ZERO                                                        AR1065986
     C*****ACST          ANDNE'C'                                                          AR1065986
      *
      ** Calculate Inactivity period of Account.
      ** If Last Movement Date is Zero use Date Acoount opened.
     C     LMVD          IFNE      *ZERO
     C     BJRDNB        SUB       LMVD          UINPD             5 0
     C                   ELSE
     C     BJRDNB        SUB       DACO          UINPD
     C                   ENDIF
      *                                                                                     AR928468
      ** Check if account is attached to SWIFT or NOSTRO                                    AR928468
      *                                                                                     AR928468
     C                   MOVE      ' '           WSWAC                                      AR928468
     C                   MOVE      ' '           WNOST                                      AR928468
     C                   MOVEL     CNUM          WCNUMA            6                        AR928468
     C     SWAKEY        KLIST                                                              AR928468
     C                   KFLD                    BRCA                                       AR928468
     C                   KFLD                    WCNUMA                                     AR928468
     C                   KFLD                    CCY                                        AR928468
     C                   KFLD                    ACOD                                       AR928468
     C                   KFLD                    ACSQ                                       AR928468
      *                                                                                     AR928468
     C     SWAKEY        CHAIN     SWACSSBW                           80                    AR928468
     C     *IN80         IFEQ      '0'                                                      AR928468
     C     RECISW        ANDNE     '*'                                                      AR928468
     C                   MOVE      'Y'           WSWAC             1                        AR928468
     C                   ENDIF                                                              AR928468
      *                                                                                     AR928468
      ** Check if account is attached to Nostro                                             AR928468
      *                                                                                     AR928468
     C                   MOVEL     ACOD          WACODA                                     AR928468
     C     KNOST         KLIST                                                              AR928468
     C                   KFLD                    WCNUMA                                     AR928468
     C                   KFLD                    CCY                                        AR928468
     C                   KFLD                    WACODA           10                        AR928468
     C                   KFLD                    ACSQ                                       AR928468
     C                   KFLD                    BRCA                                       AR928468
      *                                                                                     AR928468
     C     KNOST         CHAIN     @NOSTBH                            80                    AR928468
     C     *IN80         IFEQ      '0'                                                      AR928468
     C                   MOVE      'Y'           WNOST             1                        AR928468
     C                   ENDIF                                                              AR928468
      ** Close Account if inactive period has been exceeded
      **  and no SWIFT accounts record.                                                    AR1065986
     C     UINPD         IFGT      LINPD
     C     LINPD         ANDGT     0
     C     CGL083        ANDEQ     'Y'
     C     WSWAC         ANDNE     'Y'                                                      AR928468
     C     WNOST         ANDNE     'Y'                                                      AR928468
      *                                                                                    AR1065986
      **                                                                                   AR1065986
     C                   MOVE      CNUM          SWCNUM                                    AR1065986
     C                   MOVE      CCY           SWCCY                                     AR1065986
     C                   MOVE      ACOD          SWACOD                                    AR1065986
     C                   MOVE      ACSQ          SWACSQ                                    AR1065986
     C                   MOVE      BRCA          SWBRCA                                    AR1065986
      *                                                                                    AR1065986
      ** Check if SWIFT account present and proceed only if there is none.                 AR1065986
     C     KSWAC         CHAIN     SWACSSBF                           70                   AR1065986
      *                                                                                    AR1065986
      **                                                                                   AR1065986
     C     *IN70         IFEQ      *ON                                                     AR1065986
      *
      ** Output details to Report
     C                   ADD       1             ULRCNT
     C                   EXSR      SRPRNT
      ** Close Account
     C                   EXSR      SRCLAC
     C                   ENDIF                                                             AR1065986
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF                                                             AR1065986
      *                                                                                    AR1065986
     C                   READ      ACCBR                                  80
     C                   ENDDO
      *
      ** End of file so write trailer
      *
     C                   EXSR      SREND
      *
      ** Produce Audit Report.
      *
     C                   EXSR      SRAUDT
      *
     C                   ENDSR
      *
      /TITLE SR/SRCLAC
      *****************************************************************
      *  SRCLAC - Subroutine to Close an Account                      *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls:                                                       *
      *****************************************************************
      *
     C     SRCLAC        BEGSR
      *
      ** Update ACCNTAB
      *
     C                   MOVEL     CHTP          PCHTP             1
     C                   Z-ADD     LCD           PLCD              5 0
      *
     C                   MOVEL     'C'           ACST
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   Z-ADD     BJRDNB        DACC
      *
     C                   MOVEL     'C'           CHTP
      *
      ** Force NATN in TNLU
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          TNLU
     C                   UPDATE    ACCNTABF
      *
      ** Update ACCNTAC
      *
     C     1             SETLL     ACCNTAC
     C                   READ      ACCNTAC                                82
      *
     C     *IN82         IFEQ      '0'
     C     NOCL          ADD       1             NOCL
     C     NOAU          SUB       1             NOAU
      *
     C     PLCD          IFEQ      BJRDNB
     C     PCHTP         ANDEQ     'I'
     C                   ADD       1             NORE
     C                   SUB       1             NINU
     C                   ENDIF
      *
     C     PLCD          IFEQ      BJRDNB
     C     PCHTP         ANDEQ     'A'
     C                   SUB       1             NOAM
     C                   ENDIF
      *
      ** Force Run Date in LCD
     C                   Z-ADD     BJRDNB        LCD
     C                   Z-ADD     NATN          TNLU
     C                   UPDATE    ACCNTACF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /TITLE SR/SRPRNT
      *****************************************************************
      *  SRPRNT - Subroutine to write detail record                   *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls:                                                       *
      *****************************************************************
      *
     C     SRPRNT        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     PGHEADER                                     Page Header
     C                   WRITE     DTHEADER                                     Customer Detail
     C                   ENDIF
      *
      ** Output Account detail
      *
     C                   MOVE      BRCA          P1BRCA
     C                   MOVE      CNUM          P1CNUM
     C                   MOVE      CCY           P1CCY
     C                   MOVE      ACOD          P1ACOD
     C                   MOVE      ACSQ          P1ACSQ
     C                   MOVE      ANAM          P1ANAM
      *
      ** Output Last Movement Date/Date Account opened in DDMMMYY format
     C     LMVD          IFNE      *ZERO
     C                   Z-ADD     LMVD          ZDAYNO
     C                   ELSE
     C                   Z-ADD     DACO          ZDAYNO
     C                   ENDIF
      *
     C                   EXSR      ZDATE2
      *
     C     LMVD          IFNE      *ZERO
     C                   MOVE      ZADATE        P1LMVD
     C                   MOVE      *BLANKS       P1DACO
     C                   ELSE
     C                   MOVE      ZADATE        P1DACO
     C                   MOVE      *BLANKS       P1LMVD
     C                   ENDIF
      *
     C                   WRITE     R1DETAIL
      *
     C                   ENDSR
      *
      /TITLE SR/SREND
      *****************************************************************
      *  SREND - Subroutine to Write End of Report.                   *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls    : None                                              *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     PGHEADER
     C                   ENDIF
      *
      ** If no record processed then write 'NO RECORD TO REPORT'
      *  on the Rejection Code List report.
      *
     C     ULRCNT        IFEQ      0
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *
      ** Write Trailer
      *
     C                   WRITE     TRAILER
      *
     C                   ENDSR
      *
      /TITLE SR/SRAUDT
      *****************************************************************
      *  SRAUDT - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, SRPROC, *PSSR                    *
      *  Calls: None.                                                 *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     HEADERAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C     ULRCNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ** Write Trailer for Audit Report.
      *
     C                   WRITE     AUTRAIL
      *
      ** End Program and Return.
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *
      /TITLE SR/SRRCFP
      *****************************************************************
      *  SRRCFP  - Subroutine to register GL0083P1 via RCF.           *
      *                                                               *
      *  Called By: SRINIT                                            *
      *  Calls: None.                                                 *
      *****************************************************************
      *
     C     SRRCFP        BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PRENT             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      *  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      /TITLE SR/SRRCFA
      *****************************************************************
      *  SRRCFA - Subroutine to register GL0083AU via RCF.            *
      *                                                               *
      *  Called By: SRINIT                                            *
      *  Calls: None.                                                 *
      *****************************************************************
      *
     C     SRRCFA        BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PRENT
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     ULRUN         IFEQ      *BLANK
     C                   MOVE      'Y'           ULRUN             1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   EXSR      SRAUDT
     C                   RETURN
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      /TITLE SR/#LTERM
      *****************************************************************
      *  SRTERM   - Subroutine to do Terminate program                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *****************************************************************
      *
     C     SRTERM        BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *
      /COPY ZSRSRC,ZTNLU1Z4
      /EJECT
      /COPY ZSRSRC,ZDATE2Z2LE
      *
**  SVL
GLA/CInactivePeriod
**  CPY@
(c) Finastra International Limited 2023
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
