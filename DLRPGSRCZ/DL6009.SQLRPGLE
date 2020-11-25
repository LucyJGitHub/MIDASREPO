     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL Daily Update of History with Deal Events')    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL6009 - DAILY UPDATE OF HISTORY FILE WITH DEAL EVENTS       *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2016            *
      *                                                               *
      *  Note: This program is a copy of DL9005. If changes           *
      *        are made to DL9005, this program should also           *
      *        be reviewed.                                           *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054140           Date 27Aug19               *
      *                 CER050  *Create    Date 16Jun19               *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD054140 - APR rate is blanked out after amendment on        *
      *             Maturity Date and Next Interest Payment Date      *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     FDKEYSDP   IF   E             DISK
     FDLHISTI1  IF   E           K DISK    RENAME(DLHISTD0:XDLHISTD0)                       MD054140
     F                                     PREFIX(WF)                                       MD054140
      *
      * Output files
     FDLHISTTD  O    E             DISK
     FDL9005AU  O    E             PRINTER
      *
      /EJECT
     D ZHC             S              3    DIM(50)
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
     D DTE1            S              2  0 DIM(12) CTDATA PERRCD(12)
     D DTE2            S              2  0 DIM(12) ALT(DTE1)
      *
     D SEQ1            S              2    DIM(11) CTDATA PERRCD(11)
     D SEQ2            S              2    DIM(11) ALT(SEQ1)
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      * ACCOUNT KEY DATA STRUCTURE
     D                 DS
     D  AKEY                   1     14
     D  AKEY3                  3      3
     D  AKEY6                  6      6
     D  AKEY7                  7      7
     D  X6X7                   6      7
     D  AKEY9                  9      9
     D  X9X10                  9     10
     D  AKEY10                10     10
      *
      * RUN DATE DATA STRUCTURE
     D                 DS
     D  DAT1                   1      6  0
     D  DD1                    1      2  0
     D  MM1                    3      4  0
     D  YY1                    5      6  0
      *
      * LAST DAY OF MONTH DATA STRUCTURE
     D                 DS
     D  DAT2                   1      6  0
     D  DD2                    1      2  0
     D  MM2                    3      4  0
     D  YY2                    5      6  0
      *
      * NEXT WORKING DAY DATA STRUCTURE
     D                 DS
     D  DAT3                   1      6  0
     D  DD3                    1      2  0
     D  MM3                    3      4  0
     D  YY3                    5      6  0
      *
      /COPY ZSRSRC,ZHOLELE
      /COPY ZSRSRC,ZHOLILE
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Bank Details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** Dealing ICD
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Module Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  LCDSAR       E                     EXTFLD(LCD)
      * Switchable features details
      *
     D DEALDC        E DS                  EXTNAME(DEALSDC)
     D  RECI1        E                     EXTFLD(RECI)
     D  PCPL1        E                     EXTFLD(PCPL)
     D  ICBS1        E                     EXTFLD(ICBS)
      *
     D DLHIST        E DS                  EXTNAME(DLHISTTD)
     D                                     PREFIX(H)
      *
     D/SPACE 3
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      * Third DS For Access Programs, Very Long Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     IDKEYSDPF
     I              EAMT                        EAMT1
     I              INTR                        INTR1
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C                   EXSR      SRINIT                                       INITIALISATION
      *
      *  Process DKEYSDP until end of file
      *
     C                   Read      DKEYSDP                                20
      *
     C     *In20         Doweq     *Off
      *  Count number of records read from DKEYSDP
     C                   Add       1             DLCNT
      *
      *  On change of deal number, retrieve deals record from deals file
     C     DLNO          Ifne      ##DLNO
     C                   MoveA     '00'          *IN(74)
     C                   Z-Add     DLNO          ##DLNO
      *
     C/exec SQL
     C+ select *
     C+ into :DEALDC
     C+ from DEALSDC
     C+ where DLNO =:##DLNO
     C/end-exec

      *  Save interest calculation basis for Front Up interest Deals
     C                   MOVE      ICBS1         ICBS2             1
     C                   Endif
      *
      *  Ignore record if no record is found on DEALSDC
     C     SQLCOD        Ifeq      *Zeros
      *
      *  IGNORE THE RECORD IF THE EVENT AMOUNT FROM DKEYSDP IS ZERO
     C     EAMT1         Ifne      0
      *
      ** Set the previous deal no. to zeros if the previous
      ** account key is not for net interest due.
      *
     C     *IN80         Ifeq      '0'
     C                   Z-Add     *ZEROS        @DLNO
     C                   Z-Add     *ZEROS        @EDAT
     C                   Endif
      *
      *  IGNORE THE RECORD IF POSITION THREE OF THE ACCOUNT KEY IS
      *  EQUAL TO "A" OR "D"
     C     AKEY3         Ifne      'A'
     C     AKEY3         orne      'D'
      *
      *  PROCESS FRONT UP INTEREST DEALS CORRECTLY.
     C     FUID          Ifeq      'Y'
     C     AKEY3         andeq     'V'
      *
      *  IF POSITION TEN EQUALS "A" THEN EXECUTE SRHSTA
      *                         "I" THEN EXECUTE SRIIP
     C     AKEY10        Ifeq      'A'
     C     AKEY9         andne     'U'
     C                   Exsr      SRHSTA
     C                   Endif
      *
     C     AKEY10        Ifeq      'I'
     C                   Exsr      SRIIP
     C                   Endif
      *
     C                   Else
      *
      *  IF POSITION THREE EQUALS "V" THEN EXECUTE SRHSTA
      *                           "I" THEN EXECUTE SRIIP
      *                           "M" THEN EXECUTE SRMDP
      *
     C     AKEY6         Ifeq      ' '
     C     AKEY3         CASEQ     'V'           SRHSTA
     C     AKEY3         CASEQ     'I'           SRIIP
     C     AKEY3         CASEQ     'M'           SRMDP
     C                   END
     C                   ENDIF
      *
     C                   Endif
      *
     C                   Endif
      *
     C                   Endif
      *
     C                   Endif
      *
     C                   Read      DKEYSDP                                20
     C                   Enddo
      *
      *  Write audit report on current run of program
     C                   Write     AUDIT
      *
      *  Seton last record indicator to end program
     C                   MOVE      #ON           *INLR

      **-----------------------------------------------------------**
      **                                                           **
      ** SRDEFN- DEFINITION ROUTINE.                               **
      **                                                           **
      **-----------------------------------------------------------**
     C     SRDEFN        BEGSR
      *
     C     *LIKE         DEFINE    DLNO          ##DLNO
     C     *LIKE         DEFINE    ACSQ          X
     C     *LIKE         DEFINE    EDAT          WKDAT
     C     *LIKE         DEFINE    EDAT          CALDAT
     C     *LIKE         DEFINE    RODA          INT1
     C     *LIKE         DEFINE    PCPL          XXX
     C     *LIKE         DEFINE    CALDAT        WKDAT1
     C     *LIKE         DEFINE    BJDNWD        DNWDM1
      *
     C                   ENDSR

      **--------------------------------------------------------SRINIT
      **                                                           **
      ** SRINIT- INITIALISATION ROUTINE.                           **
      **                                                           **
      **-----------------------------------------------------------**
     C     SRINIT        BEGSR
      *
     C/exec SQL
     C+ select *
     C+ into :SCSARD
     C+ from SCSARDPD
     C+ where SARN = 'CER050'
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C                   Move      *ON           *INLR
     C                   Return
     C                   Endif
      *
     C                   MOVE      '1'           #ON               1
     C                   MOVE      '0'           #OFF              1
     C                   MOVEA     CPY@          BIS@             80
      *
     C                   MOVE      #OFF          *IN98
      *
     C                   TIME                    TIME              6 0
      *
     C/exec SQL
     C+ select *
     C+ into :SDBANK
     C+ from SDBANKPD
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C                   MOVEL     'SDBANKPD'    DBFILE           10
     C                   MOVEL     '01'          DBASE             3
     C                   MOVEL     '*FIRST'      DBOPTN            7
     C                   MOVEL     '1'           *INU7
     C                   MOVEL     '1'           *INU8
     C                   Exsr      *PSSR
     C                   Endif
      *
     C/exec SQL
     C+ select *
     C+ into :SDMMOD
     C+ from SDMMODPD
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C                   Movel     'SDMMODPD'    DBFILE
     C                   Movel     '04'          DBASE
     C                   Movel     '*FIRST'      DBOPTN
     C                   Move      *ON           *INU7
     C                   Move      *ON           *INU8
     C                   EXSR      *PSSR
     C                   Endif
     C*
     C     BJDNWD        SUB       1             DNWDM1
      *
      ** Given the rundate and the next working date, calculate the last
      ** calendar day of the month now being processed and the last
      ** working date of the current month.
      *
     C                   Z-Add     BJRDNB        ZDAYNO
      *
     C                   CALL      'ZDATE2'
     C                   Parm                    ZDayno
     C                   Parm                    BJDFIN
     C                   Parm      *Zeros        ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
      *
     C                   Z-Add     ZDATE         DAT1
      *
     C                   MOVE      #OFF          *IN73
     C                   Z-ADD     1             X
     C     MM1           LOOKUP    DTE1(X)                                73
     C     *IN73         IFEQ      #ON
     C                   MOVE      DTE2(X)       DD2
     C                   MOVE      MM1           MM2
     C                   MOVE      YY1           YY2
     C     MM1           IFEQ      02
     C     YY1           DIV       4             XXX
     C                   MVR                     REM               2 0
     C     REM           IFEQ      0
     C                   Z-ADD     29            DD2
     C                   END
     C                   END
     C                   END
      *
     C                   Z-ADD     BJDNWD        ZDAYNO
      *
     C                   CALL      'ZDATE2'
     C                   Parm                    ZDayno
     C                   Parm                    BJDFIN
     C                   Parm      *Zeros        ZDATE
     C                   Parm      *Blanks       ZADATE
     C                   Z-ADD     ZDATE         DAT3
      *
     C                   MOVE      DAT2          ZDATE
      *
     C                   CALL      'ZDATE1'
     C**********         Parm                    ZDate_1           6
     C**********         Parm                    ZDayno
     C**********         Parm                    BJDFIN
     C**********         Parm      *Blanks       ErrorFlag         1
     C                   PARM      *BLANKS       ZRTCD             7
     C                   PARM                    ZDATE
     C                   PARM                    BJDfin
     C                   PARM      *ZERO         ZDayNo
      *
     C                   Z-Add     ZDAYNO        CALDAT
      *
     C                   Z-Add     CALDAT        WKDAT1
      *
     C     MM1           Ifne      MM3
     C                   Z-Add     BJRDNB        WKDAT
     C                   Else
      *
     C     *IN72         Doueq     #ON
     C                   Z-Add     WKDAT1        ZDAYNO
     C                   Move      BJCYCD        ZCCY
     C                   Move      *BLANKS       ZLOC
      *
     C                   Exsr      ZCHKH
      *
     C**********         CALL      'ZCHKH'
     C**********         PARM                    ZDayno
     C**********         PARM                    ZCcy              3
     C**********         PARM                    ZLOC              3
     C**********         PARM      *Blanks       ZIND              1
      *
     C     ZIND          Ifeq      'W'
     C                   Move      #ON           *IN72
     C                   Move      WKDAT1        WKDAT
     C                   Else
     C                   Sub       1             WKDAT1
     C                   Endif
      *
     C                   Enddo
      *
     C                   Endif
      *
      ** Get Dealing ICD
      *
     C/exec SQL
     C+ select *
     C+ into :SDDEAL
     C+ from SDDEALPD
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C                   Movel     'SDDEALPD'    DBFILE
     C                   Movel     '02'          DBASE
     C                   Movel     '*FIRST'      DBOPTN
     C                   Movel     *BLanks       DBKEY            29
     C                   Movel     '1'           *INU7
     C                   Movel     '1'           *INU8
     C                   Exsr      *PSSR
     C                   Endif
      *
      ** Access SAR details file to see if CDL009 SAR is installed.
      *
     C                   MOVE      'N'           CDL009
      *
     C/exec SQL
     C+ select *
     C+ into :SCSARD
     C+ from SCSARDPD
     C+  where SARN = 'CDL009'
     C/end-exec

     C     SQLCOD        Ifeq      *Zeros
     C                   Move      'Y'           CDL009            1
     C                   Endif
      *
      ** Access SAR details file to see if CGL031 SAR is installed.
      *
     C/exec SQL
     C+ select *
     C+ into :SCSARD
     C+ from SCSARDPD
     C+  where SARN = 'CGL031'
     C/end-exec

     C     SQLCOD        Ifeq      *Zeros
     C                   Move      'Y'           CGL031            1
     C                   Else
     C                   Move      'N'           CGL031
     C                   Endif
      *
      ** Access SAR details file to see if CER048 SAR is installed.
      *
     C/exec SQL
     C+ select *
     C+ into :SCSARD
     C+ from SCSARDPD
     C+  where SARN = 'CER048'
     C/end-exec

     C     SQLCOD        Ifeq      *Zeros
     C                   Move      'Y'           CER048            1
     C                   Else
     C                   Move      'N'           CER048
     C                   Endif
      *
      ** Access SAR details file to see if CER054 SAR is installed.
      *
     C/exec SQL
     C+ select *
     C+ into :SCSARD
     C+ from SCSARDPD
     C+  where SARN = 'CER054'
     C/end-exec

     C     SQLCOD        Ifeq      *Zeros
     C                   Move      'Y'           CER054            1
     C                   Else
     C                   Move      'N'           CER054
     C                   Endif
      *
     C     ENDNIT        ENDSR
      *
      **--------------------------------------------------------SRHSTA
      **                                                           **
      ** SRHSTA- WRITE A RECORD TO THE HISTORY FILE WITH RECORD    **
      **         TYPE LD OR PI.                                    **
      **                                                           **
      **-----------------------------------------------------------**
     C     SRHSTA        BEGSR
      *
      *  Output a record to the History File DLHISTTD
      *  Record type LD is the Start date record
      *  Record type PI is the Principal Increase record
      *
     C     AKEY9         Ifeq      ' '
     C                   Move      'LD'          RTYP
     C                   Else
     C     AKEY9         Ifeq      'I'
     C                   Move      'PI'          RTYP
     C                   Endif
     C                   Endif
      *
      *  Set up History record.
      *  Write record and clear record after output.
      *  Keep a count of the number of records output to DLHISTTD
     C                   Exsr      SRHSTB
      *
      *  Set up FUID on History file
     C     FUID          Ifeq      'Y'
     C                   Move      'F'           INTC
     C                   Move      ICBS2         ICBS
     C                   Endif
      *
     C                   Move      'LD'          WFRTYP                                     MD054140
     C                   Move      DLNO          WFDLNO                                     MD054140
      *                                                                                     MD054140
     C     KDLHIST       KLIST                                                              MD054140
     C                   KFLD                    WFDLNO                                     MD054140
     C                   KFLD                    WFRTYP                                     MD054140
      *                                                                                     MD054140
     C     KDLHIST       CHAIN     DLHISTI1                           93                    MD054140
      *                                                                                     MD054140
     C                   IF        *IN93 = *ON                                              MD054140
     C                             OR RTYP = 'PI'                                           MD054140
     C                   WRITE     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   ENDIF                                                              MD054140
      *
     C                   ENDSR
      *
      **---------------------------------------------------------CHQI
      **                                                           **
      ** SRCHQI - Subroutine to determine the Cheque/Statement     **
      **          Indicator.                                       **
      **                                                           **
      **-----------------------------------------------------------**
     C     SRCHQI        BEGSR
      *
      *  For "IP" type records, the cheque/Statement Indicator should
      *  follow these conditions:
      *  If RCDC (DEALS) = 15 then CHQI = L for LOAN, otherwise
      *  If INTC = "Y" then CHQI = "D", otherwise
      *  If Ccy <> Base currency, then CHQI = D,
      *  Otherwise, if Event date is earlier than the end of the working
      *  month date, or greater than the end of the calendar month date,
      *  then CHQI = "D".
      *
     C                   MOVE      'IP'          RTYP
      *
     C     RCDC          Ifeq      15
     C                   Movel     'L'           CHQI
     C                   Else
     C     INTC          Ifeq      'Y'
     C                   Move      'D'           CHQI
     C                   Else
     C     CCY           Ifne      BJCYCD
     C                   Move      'D'           CHQI
     C                   Else
     C     EDAT          Iflt      WKDAT
     C     EDAT          orgt      CALDAT
     C     CDL009        oreq      'Y'
     C                   Move      'D'           CHQI
     C                   Else
     C                   Move      'C'           CHQI
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   ENDSR
      *
      **----------------------------------------------------------SRIIP
      **                                                           **
      ** IIP - WRITE AN INTEREST PAYMENT OR RECEIPT RECORD TO      **
      **       THE HISTORY FILE.                                   **
      **                                                           **
      **-----------------------------------------------------------**
     C     SRIIP         BEGSR
      *
      *  Set up History record.
      *  Write record and clear record after output.
      *  Keep a count of the number of records output to DLHISTTD
      *
     C     AKEY10        Ifeq      'S'
     C     AKEY9         Andne     'U'
     C     X6X7          Andne     '  '
     C     CGL031        Andeq     'Y'
     C     AKEY10        Oreq      'T'
     C     CGL031        Andeq     'N'
      *
     C     AKEY10        oreq      'S'
     C     AKEY9         Andne     'S'
     C     X6X7          Andne     '  '
     C     CER048        Andeq     'Y'
      *
     C     AKEY10        oreq      'S'
     C     AKEY9         Andne     'T'
     C     X6X7          Andne     '  '
     C     CER054        Andeq     'Y'
      *
     C                   Move      'TX'          RTYP
      *
     C                   Exsr      SRHSTB
     C                   WRITE     DLHISTD0
     C                   EXSR      SRHSTC
     C                   Add       1             HCNT
     C                   Else
      *
      *  Set up History record.
      *  Write record and clear record after output.
      *  Keep a count of the number of records output to DLHISTTD.
      *
     C     AKEY10        Ifeq      'N'
     C     AKEY9         andne     'U'
     C     AKEY6         andeq     ' '
     C                   Move      DLNO          @DLNO             6 0
     C                   Move      EDAT          @EDAT             6 0
     C                   Seton                                        80
     C                   Exsr      SRCHQI
     C                   Exsr      SRHSTB
     C                   WRITE     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Else
     C                   Setoff                                       80
      *
      *  Set up history record.
      *  Write record and clear record after output.
      *  Keep a count of the number of records output to DLHISTTD
      *
     C     X9X10         Ifeq      ' F'
     C                   Move      'FD'          RTYP
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Else
     C     X9X10         CABEQ     'RF'          #END
      *
      *  Set up history record.
      *  Write record and clear record after output.
      *  Keep a count of the number of records output to DLHISTTD
      *
     C     AKEY10        Ifeq      'C'
     C     AKEY9         Andne     'U'
     C                   Move      'Y'           INTC
     C                   Exsr      SRCHQI
     C                   Exsr      SRHSTB
     C                   WRITE     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Else
      *
      ** Set up history record,
      ** Write record and clear record after output.
      ** Keep a count of the number of records output to DLHISTTD
      *
     C     AKEY10        Ifeq      'I'
     C     DLNO          Andne     @DLNO
     C     EDAT          Andne     @EDAT
     C     DTYP          Ifne      'CD'
     C     BNHKTR        oreq      0
     C                   Move      ' '           INTC
     C                   Exsr      SRCHQI
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
      ** Set up history record for EU Withholding Tax
      ** Write record and clear record after output.
      ** Keep a count of the number of records output to DLHISTTD
      *
     C     CGL031        Ifeq      'Y'
     C     X6X7          andeq     '  '
     C     X9X10         andeq     'UA'
     C     CGL031        oreq      'Y'
     C     X6X7          andeq     '  '
     C     X9X10         andeq     'UE'
     C                   Move      'EU'          RTYP
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Endif
      *
     C     CER048        Ifeq      'Y'
     C     X6X7          andeq     '  '
     C     X9X10         andeq     'SA'
     C     CER048        oreq      'Y'
     C     X6X7          andeq     '  '
     C     X9X10         andeq     'SE'
     C                   Move      'ST'          RTYP
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Endif
      *
     C     CER054        Ifeq      'Y'
     C     X6X7          andeq     '  '
     C     X9X10         andeq     'TA'
     C                   Move      'CT'          RTYP
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Endif
      *
     C     #END          ENDSR
      *
      **----------------------------------------------------------SRMDP
      **                                                           **
      ** MDP - MATURITY DATE PROCESSING.                           **
      **                                                           **
      **-----------------------------------------------------------**
     C     SRMDP         BEGSR
      *
      *  Don't process records with position 10 of ACKEY = Z or I
      *
     C     AKEY10        Ifeq      'Z'
     C     AKEY10        Oreq      'I'
     C                   GOTO      #END1
     C                   Endif
      *
      *  Don't process records for Front up Interest deals unless posn 10 = 'A'
      *
     C     FUID          Ifeq      'Y'
     C     AKEY10        andne     'A'
     C                   GOTO      #END1
     C                   Endif
      *
      *  Rollover record indicator on
     C     AKEY10        Ifeq      'R'
     C                   Move      #ON           *IN74
     C                   Endif
      *
     C     AKEY10        Ifeq      'A'
     C     AKEY9         andne     'U'
     C     AKEY9         andne     'S'
     C     AKEY9         andne     'T'
      *
      *  Set up History record.
      *  Write record and clear record after output.
      *  Keep a count of the number of records output to DLHISTTD.
      *
     C     AKEY9         Ifeq      ' '
     C     *IN74         Ifeq      #OFF
     C                   Move      'MA'          RTYP
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Else
     C                   Sub       RBDA          EAMT1
     C     EAMT1         Ifgt      0
     C                   Move      'MA'          RTYP
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Endif
     C                   Endif
     C                   Else
     C     AKEY9         Ifeq      'D'
     C                   Move      'PD'          RTYP
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
     C                   Endif
     C                   Endif
      *
     C                   Else
     C     AKEY10        Ifeq      'S'
     C     AKEY9         andne     'U'
     C     X6X7          andne     '  '
     C     CGL031        andeq     'Y'
     C     AKEY10        Oreq      'T'
     C     CGL031        andeq     'N'
      *
     C     AKEY10        oreq      'S'
     C     AKEY9         andne     'S'
     C     X6X7          andne     '  '
     C     CER048        andeq     'Y'
      *
     C     AKEY10        oreq      'S'
     C     AKEY9         andne     'T'
     C     X6X7          andne     '  '
     C     CER054        andeq     'Y'
      *
     C                   Move      'TX'          RTYP
      *
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
      *
     C                   Else
     C     X9X10         Ifeq      ' F'
     C                   Move      'FD'          RTYP
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
      *
     C                   Else
     C     X9X10         CABEQ     'RF'          #END1
      *
     C     AKEY10        Ifeq      'R'
     C                   Exsr      SRCHQI
     C                   Move      'RO'          RTYP
     C                   Exsr      SRHSTB
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Add       1             HCNT
      *
     C                   Else
     C     AKEY10        Ifeq      'B'
     C     AKEY9         Andeq     ' '
     C     AKEY10        Oreq      'M'
     C                   Exsr      INT
     C                   Endif
      *
     C                   Endif
      *
     C                   Endif
      *
     C                   Endif
      *
     C                   END
      *
      ** Set up history record for EU Withholding Tax
      ** Write record and clear record after output
      ** Keep a count of the number of records output to DLHISTTD
      *
     C     CGL031        Ifeq      'Y'
     C     X6X7          ANDEQ     '  '
     C     X9X10         ANDEQ     'UA'
     C     CGL031        oreq      'Y'
     C     X6X7          ANDEQ     '  '
     C     X9X10         ANDEQ     'UE'
     C                   MOVE      'EU'          RTYP
     C                   EXSR      SRHSTB
     C                   WRITE     DLHISTD0
     C                   EXSR      SRHSTC
     C                   ADD       1             HCNT
     C                   ENDIF
      *
     C     CER048        Ifeq      'Y'
     C     X6X7          ANDEQ     '  '
     C     X9X10         ANDEQ     'SA'
     C     CER048        oreq      'Y'
     C     X6X7          ANDEQ     '  '
     C     X9X10         ANDEQ     'SE'
     C                   MOVE      'ST'          RTYP
     C                   EXSR      SRHSTB
     C                   WRITE     DLHISTD0
     C                   EXSR      SRHSTC
     C                   ADD       1             HCNT
     C                   ENDIF
      *
     C     CER054        Ifeq      'Y'
     C     X6X7          ANDEQ     '  '
     C     X9X10         ANDEQ     'TA'
     C                   MOVE      'CT'          RTYP
     C                   EXSR      SRHSTB
     C                   WRITE     DLHISTD0
     C                   EXSR      SRHSTC
     C                   ADD       1             HCNT
     C                   ENDIF
      *
     C     #END1         ENDSR
      *
      **--------------------------------------------------------SRHSTB
      **                                                           **
      ** SRHSTB- MOVE VALUES TO HISTORY FILE FIELDS BEFORE A       **
      **         RECORD IS WRITTEN TO THE HISTORY FILE.            **
      **                                                           **
      **-----------------------------------------------------------**
     C     SRHSTB        BEGSR
      *
     C                   Move      #OFF          *IN73
     C                   Z-Add     INTR          NRAT
     C                   Z-Add     NRAT          ORAT
     C                   Move      NOTD          TERM
     C                   Z-Add     1             X
     C     RTYP          LookUP    SEQ1(X)                                73
      *
     C     *IN73         Ifeq      #ON
     C                   Move      SEQ2(X)       SQNO
     C                   Else
     C                   Move      *ZEROS        SQNO
     C                   Endif
      *
     C                   Move      ' '           SECI
     C     RTYP          Ifne      'IP'
     C     RTYP          andne     'RO'
     C                   Move      'N'           CHQI
     C                   Endif
      *
     C                   Z-Add     EAMT1         EAMT
     C                   Z-Add     PCPL1         PCPL
     C                   MOVE      ICBS1         ICBS
      *
     C                   Move      *BLANKS       REPI
     C     BGN4ST        IFEQ      'Y'
     C                   MOVE      Cnum          ##Cnum            6
      *
      *** Access Customer details to retrieve Private Banking Indicator
      *
     C/exec SQL
     C+ select *
     C+ into :SDCUST
     C+ from SDCUSTPD
     C+ where BBCUST =:##Cnum
     C/end-exec

     C     SQLCOD        Ifeq      *Zeros
     C     BBPRBA        andeq     'Y'
      *
      ***  Flag this record if Repayment Type is 'IP'
      ***     and Deal Type 'CD' or 'CL'
      ***     and Private Banking Customer
      *
     C     CGL031        Ifeq      'Y'
     C     RTYP          Ifeq      'EU'
     C     DTYP          Andeq     'TD'
     C     RTYP          Oreq      'EU'
     C     DTYP          Andeq     'CD'
     C                   Move      'Y'           REPI
     C                   Endif
     C                   Endif
      *
      ***  If deal matured, no replication is needed
      *
     C     RECI1         Ifne      'M'
     C     RECI1         oreq      'M'
     C     EDAT          andne     MDAT
     C     RTYP          Ifeq      'IP'
     C     DTYP          andeq     'CD'
     C     RTYP          Oreq      'IP'
     C     DTYP          Andeq     'CL'
      *
      **   Include Time Deposit and Time Loan
     C     RTYP          Oreq      'IP'
     C     DTYP          andeq     'TD'
     C     RTYP          Oreq      'IP'
     C     DTYP          andeq     'TI'
     C     X9X10         Ifne      'TI'
     C                   Move      'Y'           REPI
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C     CGL031        Ifeq      'Y'
     C     RTYP          Ifeq      'EU'
     C     DTYP          Andeq     'TD'
     C     RTYP          Oreq      'EU'
     C     DTYP          Andeq     'CD'
     C                   Move      'Y'           REPI
     C                   Endif
      *
     C     CER048        Ifeq      'Y'
     C     RTYP          andeq     'ST'
     C     CER054        oreq      'Y'
     C     RTYP          andeq     'CT'
     C     DTYP          Ifeq      'TD'
     C     DTYP          oreq      'CD'
     C                   Move      'Y'           REPI
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   ENDSR
      *
      **----------------------------------------------------------INT
      **                                                           **
      ** INT - CALCULATE INTEREST AND THEN WRITE A RECORD TO THE   **
      **       HISTORY FILE.                                       **
      **                                                           **
      **-----------------------------------------------------------**
     C     INT           BEGSR
      *
     C                   Z-ADD     0             INT1
     C     EAMT1         ADD       RBDA          INT1
     C                   SUB       PCPL1         INT1
      *
      * If IPDS = 'Y', calculate interest amount to be paid at maturity
      *
     C     IPDS          Ifeq      'Y'
     C     RECI1         andeq     'M'
     C     AKEY3         andeq     'M'
      *
      * Set the interest to the total interest
     C                   Z-Add     TOTI          INT1
     C                   Z-Add     DLNO          @@DLNO            6 0
      *
     C/exec SQL
     C+ declare HistL1 cursor for
     C+ Select * from DLHISTTD
     C+ where DLNO =:@@DLNO
     C/end-exec

     C/exec SQL
     C+ open Histl1
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C                   EVAL      DBASE = '03'
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   EVAL      *Inu7 = *On
     C                   EVAL      *Inu8 = *On
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from HistL1
     C+ into :DLHIST
     C/end-exec

     C                   Dow       SQLCod <> 100
      *
     C     HRTYP         Ifeq      'IP'
     C     INT1          Sub       HEAMT         INT1
     C                   Endif

     C/exec SQL
     C+ fetch next
     C+ from HistL1
     C+ into :DLHIST
     C/end-exec
      *
     C                   Enddo

     C/exec SQL
     C+ close Histl1
     C/end-exec
      *
     C                   Endif
      *
     C     INT1          Ifne      0
     C                   Exsr      SRCHQI
     C                   Exsr      SRHSTB
     C                   Z-Add     INT1          EAMT
     C                   Write     DLHISTD0
     C                   Exsr      SRHSTC
     C                   Endif
      *
     C                   ENDSR
      *
      **--------------------------------------------------------SRHSTC
      **                                                           **
      ** SRHSTC- BALNK OUT ALL FIELDS FROM DEALS RECORD USED IN    **
      **         THE PROGRAM ONCE THE HISTORY RECORD HAS BEEN      **
      **         OUTPUT.                                           **
      **                                                           **
      **-----------------------------------------------------------**
     C     SRHSTC        BEGSR
      *
     C                   MOVE      '  '          RTYP
     C                   Z-ADD     0             EDAT
     C                   Z-ADD     0             PCPL
     C                   Z-ADD     0             NRAT
     C                   Z-ADD     0             ORAT
     C                   MOVE      '   '         TERM
     C                   Z-ADD     0             SQNO
     C                   MOVE      ' '           SECI
     C                   Z-ADD     0             EAMT
     C                   MOVE      ' '           CHQI
     C                   MOVE      ' '           ICBS1
      *
      *  INITIALISE FUID INDICATOR ON HISTORY FILE.
     C     INTC          IFEQ      'F'
     C                   MOVE      ' '           INTC
     C                   MOVE      ' '           ICBS2
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : *PSSR  -  Error handling subroutine             *
      *                                                               *
      *  CALLED BY  : This routine is called if there are any program *
      *               or file errors.                                 *
      *                                                               *
      *  CALLS      : none                                            *
      *                                                               *
      *  FIELDS USED: @RUN                                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          Ifeq      *BLANK
     C                   Move      'Y'           @RUN              1
     C                   Dump
     C                   Endif
      *
     C                   Move      *On           *Inu7
     C                   Move      *On           *Inu8
     C                   Move      *On           *Inlr
     C                   Return
      *
     C                   ENDSR
      *
      *****************************************************************
      /COPY ZSRSRC,ZACCHLE
      /COPY ZSRSRC,ZCHKHLE
      *****************************************************************
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   DTE1 & DTE2  LAST DAY OF MONTH ARRAY'S
013102280331043005310630073108310930103111301231
** SEQ1 & SEQ2 - DETERMINE SEQUENCE
LD01PI05PD10MA20TX25FD30IP35RO19EU27ST28CT29
** CPY@   **      OBJECT COPYRIGHT
(C) Copyright Finastra International Limited 2016
