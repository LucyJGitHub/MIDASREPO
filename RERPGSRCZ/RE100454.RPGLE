     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Interest StatementEnquiry')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100454 - Cash Management Interest Statement Enquiry        *
      *                                                               *
      *  Function: This module allows enquiry into account            *
      *            interest statement details.                        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *      
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD046682           Date 24Jul17               *
      *                 CGL165             Date 17Feb15               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG8354            Date 13Oct05               *
      *                 CSD027             Date 09Dec05               *
      *                 BG8539             Date 15Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 217184             Date 23Apr03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *      
      *  MD046248 - Finastra Rebranding                               *
      *  MD046682 - Display 'CASH MANAGEMENT' only if CRE008 is on.   *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8354 - Pair read & write commands to subfile control.     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format is not the footer before the READ    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217184 - Allow interest information up to today.             *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100454DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:RRN)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
     FREACR     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(REACRDF)
     F                                     PREFIX(R_)
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(REIACDF)
     F                                     PREFIX(R_)
     FREHISL    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(REHISPMF: REHISPPF)
     FREHRCJ    IF   E           K DISK                                                       217184
     F                                     PREFIX(C_)                                         217184
     FREHRDJ    IF   E           K DISK                                                       217184
     F                                     PREFIX(D_)                                         217184
     FACCNTBXC  IF   E           K DISK                                                       217184
     FMXRISLPD  IF   E           K DISK    INFSR(*PSSR) USROPN
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D #_CRTD          S              1    DIM(68) CTDATA PERRCD(68)
     D #_OVR1          S              1    DIM(55) CTDATA PERRCD(55)
     D #_OVR2          S              1    DIM(55) CTDATA PERRCD(55)
     D #_CLR           S              1    DIM(27) CTDATA PERRCD(27)
     D ZIR             S             11  7 DIM(11)                                            217184
     D ZIB             S             15  0 DIM(11)  ASCEND                                    217184
     D ZIN             S             13  0 DIM(11)                                            217184
     D ZIN1            S             18  5 DIM(11)                                            217184
     D ZIA             S             15  0 DIM(11)                                            217184
     D ZIA1            S             15  5 DIM(11)                                            217184
 
 
      * Account ID
     D                 DS
     D***ACCID                   1     18                                                     CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9                                                       CSD027
     D CCY                    10     12
     D***ACD                    13     16S 0                                                  CGL029
     D***ASN                    17     18S 0                                                  CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
 
      * Balance
     D                 DS
     D BALANCE                 1    100
     D DDACTN                  1      1
     D ESDAT                   2      8
     D EEDAT                   9     15
     D EACBAL                 16     35
     D ENODYS                 36     42
     D EINTRT                 43     55
     D EINTAC                 56     72
 
 
     D                 DS
     D ZOUT21                  1     21
     D ZOUT21Sign             21     21
     D ZOUT21Edit              1     22
                                                                                              217184
     D WDRAT           DS            72                                                       217184
     D  ZIRD                   1     66P 7                                                    217184
     D                                     DIM(11)                                            217184
     D ZRD01                   1      6P 7                                                    217184
     D ZRD02                   7     12P 7                                                    217184
     D ZRD03                  13     18P 7                                                    217184
     D ZRD04                  19     24P 7                                                    217184
     D ZRD05                  25     30P 7                                                    217184
     D ZRD06                  31     36P 7                                                    217184
     D ZRD07                  37     42P 7                                                    217184
     D ZRD08                  43     48P 7                                                    217184
     D ZRD09                  49     54P 7                                                    217184
     D ZRD10                  55     60P 7                                                    217184
     D ZRD11                  61     66P 7                                                    217184
     D ZRD12                  67     72P 7                                                    217184
                                                                                              217184
     D WCRAT           DS            72                                                       217184
     D  ZIRC                   1     66P 7                                                    217184
     D                                     DIM(11)                                            217184
     D ZRC01                   1      6P 7                                                    217184
     D ZRC02                   7     12P 7                                                    217184
     D ZRC03                  13     18P 7                                                    217184
     D ZRC04                  19     24P 7                                                    217184
     D ZRC05                  25     30P 7                                                    217184
     D ZRC06                  31     36P 7                                                    217184
     D ZRC07                  37     42P 7                                                    217184
     D ZRC08                  43     48P 7                                                    217184
     D ZRC09                  49     54P 7                                                    217184
     D ZRC10                  55     60P 7                                                    217184
     D ZRC11                  61     66P 7                                                    217184
     D ZRC12                  67     72P 7                                                    217184
     D*                                                                                       217184
     D WDBAL           DS            96                                                       217184
     D  ZIBD                   1     88P 0                                                    217184
     D                                     DIM(11)                                            217184
     D  ZBD01                  1      8P 0                                                    217184
     D  ZBD02                  9     16P 0                                                    217184
     D  ZBD03                 17     24P 0                                                    217184
     D  ZBD04                 25     32P 0                                                    217184
     D  ZBD05                 33     40P 0                                                    217184
     D  ZBD06                 41     48P 0                                                    217184
     D  ZBD07                 49     56P 0                                                    217184
     D  ZBD08                 57     64P 0                                                    217184
     D  ZBD09                 65     72P 0                                                    217184
     D  ZBD10                 73     80P 0                                                    217184
     D  ZBD11                 81     88P 0                                                    217184
     D  ZBD12                 89     96P 0                                                    217184
     D*                                                                                       217184
     D WCBAL           DS            96                                                       217184
     D  ZIBC                   1     88P 0                                                    217184
     D                                     DIM(11)                                            217184
     D  ZBC01                  1      8P 0                                                    217184
     D  ZBC02                  9     16P 0                                                    217184
     D  ZBC03                 17     24P 0                                                    217184
     D  ZBC04                 25     32P 0                                                    217184
     D  ZBC05                 33     40P 0                                                    217184
     D  ZBC06                 41     48P 0                                                    217184
     D  ZBC07                 49     56P 0                                                    217184
     D  ZBC08                 57     64P 0                                                    217184
     D  ZBC09                 65     72P 0                                                    217184
     D  ZBC10                 73     80P 0                                                    217184
     D  ZBC11                 81     88P 0                                                    217184
     D  ZBC12                 89     96P 0                                                    217184
     D                                                                                        217184
     D                 DS                                                                     217184
     D  SRES                   1      6  0                                                    217184
     D  ZISD                   1      2  0                                                    217184
     D  ZISM                   3      4  0                                                    217184
     D  ZISY                   5      6  0                                                    217184
     D                                                                                        217184
     D                 DS                                                                     217184
     D  FRES                   1      6  0                                                    217184
     D  ZIFD                   1      2  0                                                    217184
     D  ZIFM                   3      4  0                                                    217184
     D  ZIFY                   5      6  0                                                    217184
     D                                                                                        217184
     D                 DS                                                                     217184
     D  RESULT                 1      6  0                                                    217184
     D  ZDAY                   1      2  0                                                    217184
     D  ZMTH                   3      4  0                                                    217184
     D  ZYEAR                  5      6  0                                                    217184
     D                 DS                                                                     217184
     D  RESULX                 1      6  0                                                    217184
     D  ZMTHX                  1      2  0                                                    217184
     D  ZDAYX                  3      4  0                                                    217184
     D  ZYEARX                 5      6  0                                                    217184
                                                                                              217184
      *  Layout for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** External DS for RETAIL details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
 
 
     IACCNTABF
     I              DRIS                        XDRIS
     I              CRIS                        XCRIS
 
 
      /SPACE 5
 
      * Requested Account ID
 
     C                   MOVEL     I_RACCID      ACCID
     C                   MOVE      CUS           WrkCUS            6
     C**********         MOVE      ACD           WrkACD            4                          CGL029
     C                   MOVE      ACD           WrkACD           10                          CGL029
     C                   MOVE      ASN           WrkASN            2
     C                   EVAL      DDACC  = BRC  +  '-'  +  WrkCUS   +  '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
 
      * Access Account
 
     C                   EXSR      ACS_ACCNT
 
      * Access Retail Accrued Interest
 
     C                   EXSR      ACS_REACR
 
      * Access Retail Interest and Charges
 
     C                   EXSR      ACS_REIAC
 
      * Access Customer
 
     C                   EXSR      ACS_CUST
 
      * Access Currency
 
     C                   EXSR      ACS_CURR
                                                                                              217184
      * If REACR date is less than History Date, calculate extra interest and add to R_DAIC1  217184
                                                                                              217184
     C                   EXSR      CAL_XINTR                                                  217184
 
      * Extract Statement Lines
      * D E B I T
 
     C                   Z-ADD     BJRDNB        HISD                                         217184
     C     BMLDAI        IFEQ      'Y'
     C*****BJRDNB        SUB       1             HISD                                         217184
     C                   Z-ADD     LDID          PDID
     C                   ELSE
     C*****              Z-ADD     BJRDNB        HISD                                         217184
     C     LDID          ADD       1             PDID
     C                   ENDIF
     C                   Z-ADD     R_DAIC1       DAIC
     C                   ADD       DINT          DAIC                                         217184
     C                   Z-ADD     *ZERO         DRIP
     C                   Z-ADD     *ZERO         DRIS
     C                   Z-ADD     R_MADI        TMADI
     C                   Z-ADD     *ZERO         PMADI
     C                   MOVEL     'D'           DRCRIN
     C                   EXSR      EXT_LINES
 
      * Extract Statement Lines
      * C R E D I T
 
     C                   Z-ADD     BJRDNB        HISD                                         217184
     C     BMLDAI        IFEQ      'Y'
     C*****BJRDNB        SUB       1             HISD                                         217184
     C                   Z-ADD     LCID          PCID
     C                   ELSE
     C*****              Z-ADD     BJRDNB        HISD                                         217184
     C     LCID          ADD       1             PCID
     C                   ENDIF
     C                   Z-ADD     R_CAIC1       CAIC
     C                   ADD       CINT          CAIC                                         217184
     C                   Z-ADD     *ZERO         CRIP
     C                   Z-ADD     *ZERO         CRIS
     C                   Z-ADD     R_MACI        TMACI
     C                   Z-ADD     *ZERO         PMACI
     C                   MOVEL     'C'           DRCRIN
     C                   EXSR      EXT_LINES
 
 
      * Fill the subfile
 
     C                   EXSR      FILL_SUB
 
      * Display screen until F3, or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
      * Pass back function keys taken
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
 
      * End of program
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
     C                   MOVEL     DDDRCR        P_DDDRCR          1
 
      * Write and read screen
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C**********         WRITE     SUBFLCTL                                                   BG8539
     C                   WRITE     FOOTER
     C                   WRITE     SUBFLCTL                                                   BG8539
 
      * Read subfile control
 
     C                   READ      SUBFLCTL                               99    *
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      ** If dr/cr indicator has changed and it's valid
      ** Re-fill the subfile
 
     C     *INKC         IFNE      '1'
     C     *INKL         ANDNE     '1'
     C                   EXSR      VALID_SELECT
     C     DDDRCR        IFNE      P_DDDRCR
     C     Valid         ANDEQ     'Y'
     C                   EXSR      FILL_SUB
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill the subfile
      *****************************************************************
     C     FILL_SUB      BEGSR
 
      * Clear subfile
     C                   MOVEA     '000'         *IN(11)
     C                   Z-ADD     *ZERO         RRN
     C                   WRITE     SUBFLCTL                                     *
 
      * Read all balances for a/c
 
     C     RISLK         SETLL     MXRISLP0
     C     RISLK         READE     MXRISLP0                               99    *
     C     *IN99         DOWEQ     '0'
     C     RECTYP        ANDNE     ' '
     C     RISLK         READE     MXRISLP0                               99    *
     C                   ENDDO
 
      * Do while balances found
 
     C                   MOVEL     *BLANK        P_DRCRIN          1
 
     C     *IN99         DOWEQ     '0'
 
      * Check if record to be selected
 
     C                   EXSR      CHK_SELECT
 
     C     RecdSelect    IFEQ      'Y'
 
      * Write a total
 
     C     DRCRIN        IFNE      P_DRCRIN
     C     P_DRCRIN      ANDNE     *BLANK
     C                   EXSR      FMT_TOTAL
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
     C                   ENDIF
 
     C                   MOVEL     DRCRIN        P_DRCRIN
 
      * Write a balance
 
     C                   EXSR      FMT_BALANCE
     C                   ADD       1             RRN               4 0          *
     C                   WRITE     SUBFLREC
     C                   ENDIF
 
     C     RISLK         READE     MXRISLP0                               99    *
     C     *IN99         DOWEQ     '0'
     C     RECTYP        ANDNE     ' '
     C     RISLK         READE     MXRISLP0                               99    *
     C                   ENDDO
     C                   ENDDO
 
      * Write a total
 
     C                   EXSR      FMT_TOTAL
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
 
      * Reset subfile
 
     C                   MOVEA     '111'         *IN(11)
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format Balance
      *****************************************************************
     C     FMT_BALANCE   BEGSR
 
     C                   CLEAR                   BALANCE
 
      * Dr/cr indicator
 
     C                   MOVEL     DRCRIN        EDRCRIN
 
      * Start date
 
     C                   Z-ADD     SDATE         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        ESDAT
 
      * End date
 
     C                   Z-ADD     EDATE         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EEDAT
 
      * A/c balance
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      ACBAL         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    EACBAL
 
      * No of days
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      NODYS         ZFLD15
     C                   Z-ADD     0             ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        ENODYS
 
      * Interest rate
 
     C     INTRT         IFNE      *ZERO
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      INTRT         ZFLD15
     C                   Z-ADD     7             ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        EINTRT
     C                   ELSE
     C     EDRCRIN       IFEQ      'D'
     C     R_DICT        ANDNE     *ZERO
     C                   MOVE      R_DICT        W_ICT             2
     C                   MOVE      R_DCST        W_CST             5
     C                   EVAL      EINTRT = ' Ref:' + W_ICT + ' ' + W_CST
     C                   ENDIF
     C     EDRCRIN       IFEQ      'C'
     C     R_CICT        ANDNE     *ZERO
     C                   MOVE      R_CICT        W_ICT
     C                   MOVE      R_CCST        W_CST
     C                   EVAL      EINTRT = ' Ref:' + W_ICT + ' ' + W_CST
     C                   ENDIF
     C                   ENDIF
 
      * interest accrued
 
     C     INTACC        IFNE      0
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      INTACC        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        EINTAC
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Format Total
      *****************************************************************
     C     FMT_TOTAL     BEGSR
 
     C                   CLEAR                   BALANCE
 
      * Dr/cr indicator
 
     C                   MOVEL     P_DRCRIN      EDRCRIN
 
      * Total interest accrued
 
     C     P_DRCRIN      IFEQ      'D'
     C*****R_DAIC        ADD       R_MADI        W_TOTINT         15 0                        217184
     C     DAIC          ADD       R_MADI        W_TOTINT         15 0                        217184
     C                   ELSE
     C*****R_CAIC        ADD       R_MACI        W_TOTINT                                     217184
     C     CAIC          ADD       R_MACI        W_TOTINT                                     217184
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      W_TOTINT      ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        EINTAC
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Validate selection
      *****************************************************************
     C     VALID_SELECT  BEGSR
 
     C                   MOVE      'Y'           Valid             1
 
      * If entered, debit/credit indicator must be valid
 
     C     DDDRCR        IFNE      *BLANK
     C     DDDRCR        ANDNE     'D'
     C     DDDRCR        ANDNE     'C'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75956 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Check if record to be selected
      *****************************************************************
     C     CHK_SELECT    BEGSR
 
     C                   MOVEL     'Y'           RecdSelect        1
 
     C     DDDRCR        IFEQ      'D'
     C     DRCRIN        ANDNE     'D'
     C                   MOVEL     'N'           RecdSelect
     C                   ENDIF
 
     C     DDDRCR        IFEQ      'C'
     C     DRCRIN        ANDNE     'C'
     C                   MOVEL     'N'           RecdSelect
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue & init error indicators
      *****************************************************************
     C     CLR_MSGQ      BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   MOVEA     '000000'      *IN(51)
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C  N60              MOVEL     ACNO          DDRAN
     C  N60              MOVEL     ANAM          DDANAM
     C   60              MOVEL     *BLANK        DDRAN
     C   60              MOVEL     *BLANK        DDANAM
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access Retail Accrued Interest
      ********************************************************************
     C     ACS_REACR     BEGSR
 
     C     ACCNTK        CHAIN     REACRDF                            60        *
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access Retail Interest and Charges
      ********************************************************************
     C     ACS_REIAC     BEGSR
 
     C     ACCNTK        CHAIN     REIACDF                            60        *
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access a customer
      ********************************************************************
     C     ACS_CUST      BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WrkCUS        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY
     C                   PARM                    SDCURR
 
     C                   ENDSR
      ********************************************************************                    217184
      * Calculate extra interest                                                              217184
      ********************************************************************                    217184
     C     CAL_XINTR     BEGSR                                                                217184
                                                                                              217184
     C                   Z-ADD     BJRDNB        HISD                                         217184
                                                                                              217184
     C                   Z-ADD     *ZEROS        DINT                                         217184
     C                   Z-ADD     *ZEROS        CINT                                         217184
     C                   Z-ADD     *ZEROS        D_INRT                                       217184
     C                   Z-ADD     *ZEROS        D_INTP                                       217184
     C                   Z-ADD     *ZEROS        C_INRT                                       217184
     C                   Z-ADD     *ZEROS        C_INTP                                       217184
     C                   Z-ADD     *ZEROS        ZINTR                                        217184
     C                   Z-ADD     *ZEROS        ZLDTM                                        217184
                                                                                              217184
     C     R_LCD         IFNE      HISD                                                       217184
                                                                                              217184
     C     CRE001        IFEQ      'Y'                                                        217184
     C     ACCNTK        CHAIN     ACCNTBXC                           50                      217184
     C                   ENDIF                                                                217184
                                                                                              217184
     C                   Z-ADD     *ZEROS        D_INRT                                       217184
     C                   Z-ADD     *ZEROS        D_INTP                                       217184
     C                   Z-ADD     *ZEROS        D_INST                                       217184
     C                   Z-ADD     *ZEROS        ZINTR                                        217184
     C                   Z-ADD     *ZEROS        ZLDTM                                        217184
                                                                                              217184
     C*  Debit Processing                                                                     217184
     C                                                                                        217184
     C     R_HISB        IFGT      0                                                          217184
     C     R_MNBL        ORGT      0                                                          217184
     C                   EXSR      DRINIT                                                     217184
     C                   Endif                                                                217184
     C*                                                                                       217184
     C                   Z-ADD     D_INST        INST                                         217184
     C                                                                                        217184
     C                   Z-ADD     D_INRT        ZIRATE                                       217184
     C                   Z-ADD     D_INTP        ZICT                                         217184
     C                   Z-ADD     DRIC          ZICALC                                       217184
     C                   Z-ADD     R_LCD         ZIBEG                                        217184
     C                   Z-ADD     BJRDNB        ZIEND                                        217184
     C                                                                                        217184
     C     D_INTP        IFLT      3                                                          217184
     C     R_HISB        IFGT      0                                                          217184
     C                   Z-ADD     R_HISB        ZIAMT                                        217184
     C*                                                                                       217184
     C   57ZICT          CASEQ     0             ZICOD                                        217184
     C  N57ZICT          CASEQ     0             ZIC00                                        217184
     C     ZICT          CASEQ     1             ZIC01                                        217184
     C     ZICT          CASEQ     2             ZIC02                                        217184
     C                   ENDCS                                                                217184
     C*                                                                                       217184
     C                   Z-ADD     ZINTR         DINT                                         217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C                   ELSE                                                                 217184
     C*                                                                                       217184
     C** SEARCHING END-OF-MONTH DATE                                                          217184
     C*                                                                                       217184
     C                   EXSR      DATEIN                                                     217184
     C*                                                                                       217184
     C     BJRDNB        IFLE      ZLDTM                                                      217184
     C     R_MNBL        IFGT      0                                                          217184
     C                   Z-ADD     R_MNBL        ZIAMT                                        217184
     C     D_INTP        IFEQ      3                                                          217184
     C                   Z-ADD     1             ZICT                                         217184
     C                   ELSE                                                                 217184
     C                   Z-ADD     2             ZICT                                         217184
     C                   END                                                                  217184
     C     ZICT          CASEQ     1             ZIC01                                        217184
     C     ZICT          CASEQ     2             ZIC02                                        217184
     C                   END                                                                  217184
     C                   Z-ADD     ZINTR         DINT                                         217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   ELSE                                                                 217184
     C*                                                                                       217184
     C** IF CHANGE OF MONTH OCCURS WITH METHODS 3 & 4 THEN TWO PROCESSINGS                    217184
     C** FIRST PROCESSING:                                                                    217184
     C*                                                                                       217184
     C     R_MNBL        IFGT      0                                                          217184
     C                   Z-ADD     R_MNBL        ZIAMT                                        217184
     C                   Z-ADD     ZLDTM         ZIEND                                        217184
     C     D_INTP        IFEQ      3                                                          217184
     C                   Z-ADD     1             ZICT                                         217184
     C                   ELSE                                                                 217184
     C                   Z-ADD     2             ZICT                                         217184
     C                   END                                                                  217184
     C     ZICT          CASEQ     1             ZIC01                                        217184
     C     ZICT          CASEQ     2             ZIC02                                        217184
     C                   END                                                                  217184
     C                   Z-ADD     ZINTR         DINT                                         217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C** SECOND PROCESSING:                                                                   217184
     C*                                                                                       217184
     C     R_HISB        IFGT      0                                                          217184
     C                   Z-ADD     R_HISB        ZIAMT                                        217184
     C                   Z-ADD     ZLDTM         ZIBEG                                        217184
     C                   Z-ADD     BJRDNB        ZIEND                                        217184
     C     D_INTP        IFEQ      3                                                          217184
     C                   Z-ADD     1             ZICT                                         217184
     C                   ELSE                                                                 217184
     C                   Z-ADD     2             ZICT                                         217184
     C                   END                                                                  217184
     C     ZICT          CASEQ     1             ZIC01                                        217184
     C     ZICT          CASEQ     2             ZIC02                                        217184
     C                   END                                                                  217184
     C                   ADD       ZINTR         DINT                                         217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C** CREDIT PROCESSING                                                                    217184
     C*                                                                                       217184
                                                                                              217184
     C                   Z-ADD     *ZEROS        C_INRT                                       217184
     C                   Z-ADD     *ZEROS        C_INTP                                       217184
     C                   Z-ADD     *ZEROS        C_INST                                       217184
     C                   Z-ADD     *ZEROS        ZINTR                                        217184
     C                   Z-ADD     *ZEROS        ZLDTM                                        217184
     C*                                                                                       217184
     C     R_HISB        IFLT      0                                                          217184
     C     R_MNBL        ORLT      0                                                          217184
     C                   EXSR      CRINIT                                                     217184
     C                   Endif                                                                217184
     C*                                                                                       217184
     C                   Z-ADD     C_INST        INST                                         217184
     C*                                                                                       217184
     C                   Z-ADD     C_INRT        ZIRATE                                       217184
     C                   Z-ADD     C_INTP        ZICT                                         217184
     C                   Z-ADD     CRIC          ZICALC                                       217184
     C                   Z-ADD     R_LCD         ZIBEG                                        217184
     C                   Z-ADD     BJRDNB        ZIEND                                        217184
     C*                                                                                       217184
     C     C_INTP        IFLT      3                                                          217184
     C     R_HISB        IFLT      0                                                          217184
     C                   Z-ADD     R_HISB        ZIAMT                                        217184
     C*                                                                                       217184
     C     ZICT          CASEQ     0             ZIC00                                        217184
     C     ZICT          CASEQ     1             ZIC01                                        217184
     C     ZICT          CASEQ     2             ZIC02                                        217184
     C                   ENDCS                                                                217184
     C                   Z-ADD     ZINTR         CINT                                         217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C                   ELSE                                                                 217184
     C*                                                                                       217184
     C** SEARCHING END-OF-MONTH DATE                                                          217184
     C*                                                                                       217184
     C                   EXSR      DATEIN                                                     217184
     C*                                                                                       217184
     C     BJRDNB        IFLE      ZLDTM                                                      217184
     C     R_MNBL        IFGT      0                                                          217184
     C                   Z-ADD     R_MNBL        ZIAMT                                        217184
     C     C_INTP        IFEQ      3                                                          217184
     C                   Z-ADD     1             ZICT                                         217184
     C                   ELSE                                                                 217184
     C                   Z-ADD     2             ZICT                                         217184
     C                   END                                                                  217184
     C     ZICT          CASEQ     1             ZIC01                                        217184
     C     ZICT          CASEQ     2             ZIC02                                        217184
     C                   END                                                                  217184
     C                   Z-ADD     ZINTR         CINT                                         217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   ELSE                                                                 217184
     C*                                                                                       217184
     C     R_MNBL        IFGT      0                                                          217184
     C                   Z-ADD     R_MNBL        ZIAMT                                        217184
     C                   Z-ADD     ZLDTM         ZIEND                                        217184
     C     C_INTP        IFEQ      3                                                          217184
     C                   Z-ADD     1             ZICT                                         217184
     C                   ELSE                                                                 217184
     C                   Z-ADD     2             ZICT                                         217184
     C                   END                                                                  217184
     C     ZICT          CASEQ     1             ZIC01                                        217184
     C     ZICT          CASEQ     2             ZIC02                                        217184
     C                   END                                                                  217184
     C                   Z-ADD     ZINTR         CINT                                         217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C** SECOND PROCESSING:                                                                   217184
     C*                                                                                       217184
     C     R_HISB        IFGT      0                                                          217184
     C                   Z-ADD     R_HISB        ZIAMT                                        217184
     C                   Z-ADD     ZLDTM         ZIBEG                                        217184
     C                   Z-ADD     BJRDNB        ZIEND                                        217184
     C     C_INTP        IFEQ      3                                                          217184
     C                   Z-ADD     1             ZICT                                         217184
     C                   ELSE                                                                 217184
     C                   Z-ADD     2             ZICT                                         217184
     C                   END                                                                  217184
     C     ZICT          CASEQ     1             ZIC01                                        217184
     C     ZICT          CASEQ     2             ZIC02                                        217184
     C                   END                                                                  217184
     C                   ADD       ZINTR         CINT                                         217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                                                                                        217184
     C                   ENDSR                                                                217184
      *********************************************************************                   217184
     C**                                                                                      217184
     C** DRINIT subroutine for debit rates loading                                            217184
     C**                                                                                      217184
      *********************************************************************                   217184
     C     DRINIT        BEGSR                                                                217184
     C*                                                                                       217184
     C                   Z-ADD     *ZEROS        ZIRD                                         217184
     C                   Z-ADD     *ZEROS        ZIBD                                         217184
     C                   Z-ADD     *ZERO         ZITHR                                        217184
     C                   Z-ADD     *ZEROS        D_INTH                                       217184
     C*                                                                                       217184
     C** CHAIN TO DEBIT RATE CHANGES FILE                                                     217184
     C*                                                                                       217184
     C                   Z-ADD     DRCD          KDATE                                        217184
     C*                                                                                       217184
     C     DCKEY         CHAIN     REHRDJ                             99                      217184
     C*                                                                                       217184
     C** ERROR IN REHRDJ                                                                      217184
     C*                                                                                       217184
     C     *IN99         IFEQ      '1'                                                        217184
     C     DRIB          ANDEQ     *ZEROS                                                     217184
     C     DRIS          ANDEQ     *ZEROS                                                     217184
     C     OLDR          ORNE      *ZEROS                                                     217184
     C                   MOVE      '0'           *IN99                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C** PICK-UP DEBIT THRESHOLD BALANCE                                                      217184
     C*                                                                                       217184
     C                   Z-ADD     D_INTH        ZITHR                                        217184
     C*                                                                                       217184
     C** SETUP WORK DEBIT FIELDS WITH FIELDS READ                                             217184
     C*                                                                                       217184
     C     D_RAT2        IFNE      *BLANKS                                                    217184
     C                   MOVEL     D_RAT2        WDRAT                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C     D_RAT3        IFNE      *BLANKS                                                    217184
     C                   MOVE      D_RAT3        WDRAT                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C     D_BAL2        IFNE      *BLANKS                                                    217184
     C                   MOVEL     D_BAL2        WDBAL                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C     D_BAL3        IFNE      *BLANKS                                                    217184
     C                   MOVE      D_BAL3        WDBAL                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C** LOADING OF DEBIT INTEREST RATES AND DEBIT INTEREST BALANCES                          217184
     C*                                                                                       217184
     C                   Z-ADD     ZIRD          ZIR                                          217184
     C                   Z-ADD     ZIBD          ZIB                                          217184
     C*                                                                                       217184
     C                   ENDSR                                                                217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C** CRINIT subroutine for credit rates loading                                           217184
     C**                                                                                      217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C     CRINIT        BEGSR                                                                217184
     C*                                                                                       217184
     C*                                                                                       217184
     C                   Z-ADD     *ZEROS        ZIRC                                         217184
     C                   Z-ADD     *ZEROS        ZIBC                                         217184
     C                   Z-ADD     *ZERO         ZITHR                                        217184
     C                   Z-ADD     *ZEROS        C_INTH                                       217184
     C*                                                                                       217184
     C** CHAIN TO Credit rate changes file                                                    217184
     C*                                                                                       217184
     C                   Z-ADD     CRCD          KDATE                                        217184
     C*                                                                                       217184
     C     DCKEY         CHAIN     REHRCJ                             99                      217184
     C*                                                                                       217184
     C** ERROR IN REHRCJ                                                                      217184
     C*                                                                                       217184
     C     *IN99         IFEQ      '1'                                                        217184
     C     CRIB          ANDEQ     *ZEROS                                                     217184
     C     CRIS          ANDEQ     *ZEROS                                                     217184
     C     OLCR          ORNE      *ZEROS                                                     217184
     C                   MOVE      '0'           *IN99                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C** PICK-UP CREDIT THRESHOLD BALANCE                                                     217184
     C*                                                                                       217184
     C                   Z-ADD     C_INTH        ZITHR                                        217184
     C*                                                                                       217184
     C** SETUP WORK CREDIT FIELDS WITH FIELDS READ PROCESSING                                 217184
     C*                                                                                       217184
     C     C_RAT2        IFNE      *BLANKS                                                    217184
     C                   MOVEL     C_RAT2        WCRAT                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C     C_RAT3        IFNE      *BLANKS                                                    217184
     C                   MOVE      C_RAT3        WCRAT                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C     C_BAL2        IFNE      *BLANKS                                                    217184
     C                   MOVEL     C_BAL2        WCBAL                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C     C_BAL3        IFNE      *BLANKS                                                    217184
     C                   MOVE      C_BAL3        WCBAL                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C** LOADING OF DEBIT INTEREST RATES AND DEBIT INTEREST BALANCES                          217184
     C*                                                                                       217184
     C                   Z-ADD     ZIRC          ZIR                                          217184
     C                   Z-ADD     ZIBC          ZIB                                          217184
     C*                                                                                       217184
     C*                                                                                       217184
     C                   ENDSR                                                                217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C** ZICOD subroutine to calculate interest with overdraft                                217184
     C**                                                                                      217184
     C********************************************************************                    217184
     C     ZICOD         BEGSR                                                                217184
      *                                                                                       217184
      ** Initialise work fields                                                               217184
      *                                                                                       217184
     C                   Z-ADD     *ZEROS        FINTR            15 0                        217184
     C                   Z-ADD     *ZEROS        FOINT            15 0                        217184
     C                   Z-ADD     *ZEROS        FDINT            15 0                        217184
      *                                                                                       217184
      ** Set overdraft line amount with decimal places of currency                            217184
      *                                                                                       217184
     C                   SELECT                                                               217184
     C     A6NBDP        Wheneq    0                                                          217184
     C     1             MULT      ODLN          FODLN            15 0                        217184
     C     A6NBDP        Wheneq    1                                                          217184
     C     10            MULT      ODLN          FODLN                                        217184
     C     A6NBDP        Wheneq    2                                                          217184
     C     100           MULT      ODLN          FODLN                                        217184
     C     A6NBDP        Wheneq    3                                                          217184
     C     1000          MULT      ODLN          FODLN                                        217184
     C                   EndSL                                                                217184
      *                                                                                       217184
      **  If history balance is more than work overdraft line, and                            217184
      **  the additional overdraft interest rate is non-zero and the                          217184
      **  end date of the period is less than or equal to the overdraft                       217184
      **  expiry date.                                                                        217184
      *                                                                                       217184
     C     R_HISB        IFGT      FODLN                                                      217184
     C     ATAODR        ANDNE     0                                                          217184
     C     ZIEND         ANDLE     ODED                                                       217184
     C                   Z-ADD     R_HISB        ZIAMT                                        217184
      *                                                                                       217184
     C                   EXSR      ZIC00                                                      217184
      *                                                                                       217184
      ** Set the interest field to the returned interest amount                               217184
     C                   Z-ADD     ZINTR         FINTR                                        217184
      *                                                                                       217184
      ** Initialise work fields                                                               217184
      *                                                                                       217184
     C     R_HISB        SUB       FODLN         ZIAMT                                        217184
     C                   Z-ADD     ATAODR        ZIRATE                                       217184
      *                                                                                       217184
     C                   EXSR      ZIC00                                                      217184
      *                                                                                       217184
     C                   Z-ADD     ZINTR         FOINT                                        217184
     C     FOINT         ADD       FINTR         FDINT                                        217184
      *                                                                                       217184
     C                   ELSE                                                                 217184
      *                                                                                       217184
     C     ZIEND         IFGT      ODED                                                       217184
     C     ODED          ANDGT     *ZEROS                                                     217184
      *                                                                                       217184
     C                   Z-ADD     R_HISB        ZIAMT                                        217184
     C                   EXSR      ZIC00                                                      217184
     C                   Z-ADD     ZINTR         FINTR                                        217184
      *                                                                                       217184
     C                   Z-ADD     R_HISB        ZIAMT                                        217184
     C                   Z-ADD     ATAODR        ZIRATE                                       217184
     C                   EXSR      ZIC00                                                      217184
      *                                                                                       217184
     C                   Z-ADD     ZINTR         FOINT                                        217184
      *                                                                                       217184
      ** Reset the interest calculation work fields                                           217184
      *                                                                                       217184
     C     FOINT         ADD       FINTR         FDINT                                        217184
     C                   ELSE                                                                 217184
     C                   Z-ADD     R_HISB        ZIAMT                                        217184
     C                   EXSR      ZIC00                                                      217184
     C                   Z-ADD     ZINTR         FDINT                                        217184
     C                   END                                                                  217184
      *                                                                                       217184
     C                   END                                                                  217184
     C                   Z-ADD     FDINT         ZINTR                                        217184
      *                                                                                       217184
     C                   ENDSR                                                                217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C** ZIC00 subroutine to calculate interest (type=00)                                     217184
     C**                                                                                      217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C     ZIC00         BEGSR                                                                217184
     C*                                                                                       217184
     C** REVERSE SIGN OF AMOUNT IF IT'S NEGATIVE                                              217184
     C*                                                                                       217184
     C     ZIAMT         IFLT      0                                                          217184
     C                   Z-SUB     ZIAMT         ZIAMT                                        217184
     C                   ENDIF                                                                217184
     C*                                                                                       217184
     C** FIND NUMBER OF DAYS TO CALCULATE INTEREST ACCORDING TO CALC. BASIS                   217184
     C*                                                                                       217184
     C                   EXSR      ZICD                                                       217184
     C*                                                                                       217184
     C     ZIAMT         MULT      ZDAYN2        WWMULT           15 0                        217184
     C     WWMULT        DIV(H)    100           WWDIV            15 0                        217184
     C     WWDIV         MULT      ZIRATE        WWRATE           15 0                        217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      7                                                          217184
     C     ZICALC        OREQ      5                                                          217184
     C     ZICALC        OREQ      3                                                          217184
     C     ZICALC        OREQ      2                                                          217184
     C     WWRATE        DIV(H)    360           ZIWRK1                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      4                                                          217184
     C     ZICALC        OREQ      1                                                          217184
     C     WWRATE        DIV(H)    365           ZIWRK1                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      6                                                          217184
     C     WWRATE        DIV(H)    366           ZIWRK1                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C                   Z-ADD(H)  ZIWRK1        ZINTR                                        217184
     C*                                                                                       217184
     C                   ENDSR                                                                217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C** ZIC01 subroutine to calculate interest (type=01)                                     217184
     C**                                                                                      217184
     C********************************************************************                    217184
     C     ZIC01         BEGSR                                                                217184
     C*                                                                                       217184
     C** REVERSE SIGN OF AMOUNT IF IT'S NEGATIVE                                              217184
     C*                                                                                       217184
     C     ZIAMT         IFLT      0                                                          217184
     C                   Z-SUB     ZIAMT         ZIAMT                                        217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C** INITIALIZE WORK FIELDS                                                               217184
     C*                                                                                       217184
     C                   Z-ADD     ZIAMT         ZIAMT1                                       217184
     C                   Z-ADD     1             Z                                            217184
     C                   Z-ADD     *ZEROS        ZIAMTR                                       217184
     C                   Z-ADD     *ZEROS        ZIA                                          217184
     C                   Z-ADD     *ZEROS        ZIA1                                         217184
     C                   Z-ADD     *ZEROS        LOOP              1 0                        217184
     C                   Z-ADD     *ZEROS        Y                                            217184
     C                   Z-ADD     *ZEROS        ZIN                                          217184
     C*                                                                                       217184
      *  INTEREST IS ONLY CALCULATED ON AN AMOUNT THAT EXCEEDS THE        103460              217184
      *  INITIAL THRESHOLD BALANCE                                        103460              217184
     C*                                                                                       217184
     C     ZIAMT         IFGT      ZITHR                                                      217184
     C*                                                                                       217184
     C** FIND NUMBER OF DAYS TO CALCULATE INTEREST ACCORDING TO CALC. BASIS                   217184
     C*                                                                                       217184
     C                   EXSR      ZICD                                                       217184
     C*                                                                                       217184
     C     LOOP          DOWEQ     0                                                          217184
     C                   Z-ADD     ZIAMT1        ZIAMTR                                       217184
     C*                                                                                       217184
     C     Z             IFEQ      11                                                         217184
     C                   Z-ADD     ZIAMTR        ZIA(Z)                                       217184
     C                   Z-ADD     1             LOOP                                         217184
     C*                                                                                       217184
     C                   ELSE                                                                 217184
     C                   ADD       1             Y                                            217184
     C                   ADD       1             Z                                            217184
     C*                                                                                       217184
     C     ZIB(Z)        IFEQ      0                                                          217184
     C                   ADD       ZIAMTR        ZIA(Y)                                       217184
     C                   Z-ADD     1             LOOP                                         217184
     C*                                                                                       217184
     C                   ELSE                                                                 217184
     C     ZIB(Z)        SUB       ZIB(Y)        ZBAL                                         217184
     C     ZIAMTR        SUB       ZBAL          ZIAMT1                                       217184
     C*                                                                                       217184
     C     ZIAMT1        IFLE      0                                                          217184
     C                   ADD       ZIAMTR        ZIA(Y)                                       217184
     C                   Z-ADD     1             LOOP                                         217184
     C*                                                                                       217184
     C                   ELSE                                                                 217184
     C                   ADD       ZBAL          ZIA(Y)                                       217184
     C*                                                                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C                   ENDDO                                                                217184
     C*                                                                                       217184
     C* IF THE SUB-TYPE IS FROM 50000 TO 99999, CALCULATE THE INTEREST                        217184
     C* ON THE AMOUNT EXCEEDING THE INITIAL THRESHOLD. OTHERWISE, THE                         217184
     C* INTEREST IS CALCULATED ON THE WHOLE BALANCE WHENEVER IT EXCEEDS                       217184
     C* THE INITIAL THRESHOLD.                                                                217184
     C*                                                                                       217184
     C     INST          IFGE      50000                                                      217184
     C                   Z-ADD     1             Z                                            217184
     C     Z             DOWLT     12                                                         217184
     C     ZITHR         ANDGT     0                                                          217184
     C     ZIA(Z)        SUB       ZITHR         ZIA(Z)                                       217184
     C     ZIA(Z)        IFLT      0                                                          217184
     C                   Z-SUB     ZIA(Z)        ZITHR                                        217184
     C                   Z-ADD     0             ZIA(Z)                                       217184
     C                   ELSE                                                                 217184
     C                   Z-ADD     0             ZITHR                                        217184
     C                   END                                                                  217184
     C                   ADD       1             Z                                            217184
     C                   END                                                                  217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C     ZIA           MULT      ZDAYN2        ZIA                                          217184
     C     ZIA           DIV       100           ZIA                                          217184
     C     ZIA           MULT      ZIR           ZIA                                          217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      7                                                          217184
     C     ZICALC        OREQ      5                                                          217184
     C     ZICALC        OREQ      3                                                          217184
     C     ZICALC        OREQ      2                                                          217184
     C     ZIA           DIV(H)    360           ZIN1                                         217184
     C*                                                                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      4                                                          217184
     C     ZICALC        OREQ      1                                                          217184
     C     ZIA           DIV(H)    365           ZIN1                                         217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      6                                                          217184
     C     ZIA           DIV(H)    366           ZIN1                                         217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C                   XFOOT(H)  ZIN1          ZINTR1           18 5                        217184
     C                   Z-ADD(H)  ZINTR1        ZINTR                                        217184
     C*                                                                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C*                                                                                       217184
     C                   ENDSR                                                                217184
     C********************************************************************                    217184
     C/EJECT                                                                                  217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C** ZIC02 subroutine to calculate interest (type=02)                                     217184
     C**                                                                                      217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C     ZIC02         BEGSR                                                                217184
     C*                                                                                       217184
     C** FILL THE END OF THE TABLE WITH HIGHVAL                                               217184
     C*                                                                                       217184
     C                   Z-ADD     2             Z                                            217184
     C     Z             DOWLE     11                                                         217184
     C     ZIB(Z)        IFEQ      *ZEROS                                                     217184
     C                   Z-ADD     *HIVAL        ZIB(Z)                                       217184
     C                   END                                                                  217184
     C                   ADD       1             Z                                            217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C** REVERSE SIGN OF AMOUNT IF IT'S NEGATIVE                                              217184
     C*                                                                                       217184
     C     ZIAMT         IFLT      0                                                          217184
     C                   Z-SUB     ZIAMT         ZIAMT                                        217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
      *  INTEREST IS ONLY CALCULATED ON AN AMOUNT THAT EXCEEDS THE                            217184
      *  INITIAL THRESHOLD BALANCE                                                            217184
     C*                                                                                       217184
     C     ZIAMT         IFGT      ZITHR                                                      217184
     C*                                                                                       217184
     C** FIND NUMBER OF DAYS TO CALCULATE INTEREST ACCORDING TO CALC. BASIS                   217184
     C*                                                                                       217184
     C                   EXSR      ZICD                                                       217184
     C*                                                                                       217184
     C                   Z-ADD     1             Z                                            217184
     C*                                                                                       217184
     C     ZIAMT         LOOKUP    ZIB(Z)                             41                      217184
     C*                                                                                       217184
     C* IF THE SUB-TYPE IS FROM 50000 TO 99999, CALCULATE THE INTEREST                        217184
     C* ON THE AMOUNT EXCEEDING THE INITIAL THRESHOLD. OTHERWISE, THE                         217184
     C* INTEREST IS CALCULATED ON THE WHOLE BALANCE WHENEVER IT EXCEEDS                       217184
     C* THE INITIAL THRESHOLD.                                                                217184
     C*                                                                                       217184
     C     INST          IFGE      50000                                                      217184
     C     ZIAMT         SUB       ZITHR         ZIAMT                                        217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C     ZIAMT         MULT      ZDAYN2        WWMUL3           15 0                        217184
     C     WWMUL3        DIV(H)    100           WWDIV3           15 0                        217184
     C     WWDIV3        MULT      ZIR(Z)        WWZIR            15 0                        217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      7                                                          217184
     C     ZICALC        OREQ      5                                                          217184
     C     ZICALC        OREQ      3                                                          217184
     C     ZICALC        OREQ      2                                                          217184
     C     WWZIR         DIV(H)    360           ZIWRK1                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      4                                                          217184
     C     ZICALC        OREQ      1                                                          217184
     C     WWZIR         DIV(H)    365           ZIWRK1                                       217184
     C                   Endif                                                                217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      6                                                          217184
     C     WWZIR         DIV(H)    366           ZIWRK1                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C                   ADD(H)    ZIWRK1        ZINTR                                        217184
     C*                                                                                       217184
     C                   ENDif                                                                217184
     C*                                                                                       217184
     C                   ENDSR                                                                217184
     C********************************************************************                    217184
     C     ZICD          BEGSR                                                                217184
     C*                                                                                       217184
     C** TO DETERMINE NUMBER OF DAYS INTEREST TO BE CALCULATED                                217184
     C*                                                                                       217184
     C     ZIEND         SUB       ZIBEG         ZDAYN2                                       217184
     C*                                                                                       217184
     C** CHECK FOR INTEREST CALCULATION BASIS                                                 217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      3                                                          217184
     C     ZIEND         IFGT      ZIBEG                                                      217184
     C*                                                                                       217184
     C** CALCULATING DATE FROM DAY NUMBER (BEGINNTNG DATE)                                    217184
     C*                                                                                       217184
     C                   Z-ADD     ZIBEG         ZDAYNO                                       217184
     C                   EXSR      ZDATE2                                                     217184
     C*                                                                                       217184
     C                   MOVE      ZDATEN        SRES                                         217184
     C*                                                                                       217184
     C** CALCULATING DATE FROM DAY NUMBER (FINISHING DATE)                                    217184
     C*                                                                                       217184
     C                   Z-ADD     ZIEND         ZDAYNO                                       217184
     C                   EXSR      ZDATE2                                                     217184
     C*                                                                                       217184
     C                   MOVE      ZDATEN        FRES                                         217184
     C*                                                                                       217184
     C** IN ORDER FOR THE FINISH YEAR TO BE LESS THAN THE START YEAR IF ZIEND                 217184
     C** IS GREATER THAN ZIBEG, THEN THE DATE ZIEND MUST BE IN A DIFFERENT                    217184
     C** CENTURY TO ZIBEG. IF SO ADD 100 YEARS TO IT.                                         217184
     C*                                                                                       217184
     C     ZIFY          IFLT      ZISY                                                       217184
     C     ZIFY          ADD       100           ZIFY2             3 0                        217184
     C                   ELSE                                                                 217184
     C                   Z-ADD     ZIFY          ZIFY2                                        217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   Z-ADD     ZISY          ZISY2             3 0                        217184
     C*                                                                                       217184
     C** DETERMINE WHETHER START YEAR IS A LEAP YEAR AND IF START MONTH                       217184
     C** IS FEBRUARY  THEN CONSIDER LAST DAY OF FEBRUARY AS DATE 30ND. OF THE                 217184
     C** MONTH                                                                                217184
     C*                                                                                       217184
     C     ZISM          IFEQ      2                                                          217184
     C     ZISY2         ADD       1900          ZLYCHK            4 0                        217184
     C     ZLYCHK        DIV       4             ZLYCHK                                       217184
     C                   MVR                     ZLYREM            2 0                        217184
     C     ZLYREM        IFEQ      0                                                          217184
     C     ZISD          IFEQ      29                                                         217184
     C                   Z-ADD     30            ZISD                                         217184
     C                   END                                                                  217184
     C                   ELSE                                                                 217184
     C     ZISD          IFEQ      28                                                         217184
     C                   Z-ADD     30            ZISD                                         217184
     C                   END                                                                  217184
     C                   END                                                                  217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C     30            SUB       ZISD          ZID1                                         217184
     C*                                                                                       217184
     C     ZID1          IFLT      0                                                          217184
     C                   Z-ADD     *ZEROS        ZID1                                         217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C     ZISM          IFEQ      12                                                         217184
     C                   Z-ADD     *ZEROS        ZISM                                         217184
     C                   ADD       1             ZISY                                         217184
     C                   ADD       1             ZISY2                                        217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C** DETERMINE WHETHER END YEAR IS A LEAP YEAR AND IF END MONTH IS FEBRUARY               217184
     C*                                                                                       217184
     C     ZIFM          IFEQ      2                                                          217184
     C     ZIFY2         ADD       1900          ZLYCHK            4 0                        217184
     C     ZLYCHK        DIV       4             ZLYCHK                                       217184
     C                   MVR                     ZLYREM            2 0                        217184
     C     ZLYREM        IFEQ      0                                                          217184
     C     ZIFD          IFEQ      29                                                         217184
     C                   Z-ADD     30            ZIFD                                         217184
     C                   END                                                                  217184
     C                   ELSE                                                                 217184
     C     ZIFD          IFEQ      28                                                         217184
     C                   Z-ADD     30            ZIFD                                         217184
     C                   END                                                                  217184
     C                   END                                                                  217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C     ZIFD          IFEQ      31                                                         217184
     C                   ADD       30            ZID1                                         217184
     C                   ELSE                                                                 217184
     C                   ADD       ZIFD          ZID1                                         217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   SUB       1             ZIFM                                         217184
     C*                                                                                       217184
     C     ZISY          IFEQ      ZIFY                                                       217184
     C     ZIFM          SUB       ZISM          ZINOM             3 0                        217184
     C                   ELSE                                                                 217184
     C     12            SUB       ZISM          ZIM1                                         217184
     C                   Z-ADD     1             ZISM                                         217184
     C*                                                                                       217184
     C** USE ENLARGE FIELDS THAT CAN HANDLE 1999 ONWARDS                                      217184
     C*                                                                                       217184
     C                   ADD       1             ZISY2                                        217184
     C     ZIFY2         SUB       ZISY2         ZIY1                                         217184
     C     ZIY1          MULT      12            ZIM2              3 0                        217184
     C     ZIM2          ADD       ZIFM          ZIM2                                         217184
     C     ZIM2          ADD       ZIM1          ZINOM                                        217184
     C*                                                                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C     ZINOM         MULT      30            ZID2                                         217184
     C     ZID2          ADD       ZID1          ZDAYN2                                       217184
     C*                                                                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C     ZICALC        IFEQ      4                                                          217184
     C     ZICALC        OREQ      5                                                          217184
     C*                                                                                       217184
     C** ONE DAY IS SUBTRACTED FROM ZDAYN2 FOR EACH OCCURANCE OF 29 FEB IN THE                217184
     C** THE INTEREST CALCULATION PERIOD INCLUSIVE OF ZIBEG AND ZIEND                         217184
     C*                                                                                       217184
     C** FIND NO OF FOUR YEAR PERIODS BETWEEN DATES                                           217184
     C*                                                                                       217184
     C     ZDAYN2        DIV       1461          ZIMAN                                        217184
     C                   MVR                     ZIREM                                        217184
     C*                                                                                       217184
     C** FIND NEXT 29 FEB DAY NO. ON OR AFTER ZIBEG.                                          217184
     C*                                                                                       217184
     C     ZIBEG         SUB       60            ZIBW1                                        217184
     C     ZIBW1         DIV       1461          ZIDW1                                        217184
     C                   MVR                     ZIDREM                                       217184
     C*                                                                                       217184
     C     ZIDREM        IFEQ      0                                                          217184
     C                   Z-ADD     ZIBEG         ZIDW2                                        217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C** ROUND UP RESULT                                                                      217184
     C*                                                                                       217184
     C     ZIDW1         ADD       1             ZIDW2                                        217184
     C*                                                                                       217184
     C** CALCULATE NEXT 29 FEB.                                                               217184
     C*                                                                                       217184
     C     ZIDW2         MULT      1461          ZIDW2                                        217184
     C     ZIDW2         ADD       60            ZIDW2                                        217184
     C*                                                                                       217184
     C** IF THIS NEXT 29 FEB. DAYNO - ZIBEG IS GREATER OR EQUAL TO ZIREM THEN                 217184
     C** ADD 1 TO ZIMAN.                                                                      217184
     C*                                                                                       217184
     C     ZIDW2         SUB       ZIBEG         ZILPCP                                       217184
     C*                                                                                       217184
     C     ZIREM         IFGE      ZILPCP                                                     217184
     C                   ADD       1             ZIMAN                                        217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C** SUBTRACT ZIMAN FROM ZDAYN2 TO GIVE VALUE OF ZDAYN2 REQUIRED FOR THIS                 217184
     C** INTEREST CALCULATION                                                                 217184
     C*                                                                                       217184
     C     ZDAYN2        SUB       ZIMAN         ZDAYN2                                       217184
     C*                                                                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   ENDSR                                                                217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C** DATEIN subroutine for date init processing                                           217184
     C**                                                                                      217184
     C********************************************************************                    217184
     C**                                                                                      217184
     C     DATEIN        BEGSR                                                                217184
     C*                                                                                       217184
     C** WORK FIELD INIT                                                                      217184
     C*                                                                                       217184
     C                   Z-ADD     *ZEROS        ZLDTM                                        217184
     C*                                                                                       217184
     C** CALCULATING DATE FROM DAY NUMBER (REACR HISTORY DATE)                                217184
     C*                                                                                       217184
     C                   Z-ADD     R_LCD         ZDAYNO                                       217184
     C                   EXSR      ZDATE2                                                     217184
     C*                                                                                       217184
     C** CALCULATING FIRST DAY OF THIS MONTH TO CALCULATE THE LAST ONE                        217184
     C*                                                                                       217184
     C     BJDFIN        IFEQ      'D'                                                        217184
     C                   MOVE      ZDATEN        RESULT                                       217184
     C                   Z-ADD     1             ZDAY                                         217184
     C                   MOVE      RESULT        ZDATEI                                       217184
     C                   ELSE                                                                 217184
     C                   MOVE      ZDATEN        RESULX                                       217184
     C                   Z-ADD     1             ZDAYX                                        217184
     C                   MOVE      RESULX        ZDATEI                                       217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   EXSR      ZDATE1                                                     217184
     C*                                                                                       217184
     C     BJDFIN        IFEQ      'D'                                                        217184
     C     ZMTH          IFEQ      12                                                         217184
     C                   Z-ADD     1             ZMTH                                         217184
     C                   ADD       1             ZYEAR                                        217184
     C                   ELSE                                                                 217184
     C                   ADD       1             ZMTH                                         217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   MOVE      RESULT        ZDATEI                                       217184
     C                   ELSE                                                                 217184
     C     ZMTHX         IFEQ      12                                                         217184
     C                   Z-ADD     1             ZMTHX                                        217184
     C                   ADD       1             ZYEARX                                       217184
     C                   ELSE                                                                 217184
     C                   ADD       1             ZMTHX                                        217184
     C                   END                                                                  217184
     C*                                                                                       217184
     C                   MOVE      RESULX        ZDATEI                                       217184
     C                   END                                                                  217184
     C                   EXSR      ZDATE1                                                     217184
     C*                                                                                       217184
     C     ZDAYNO        SUB       1             ZLDTM                                        217184
     C*                                                                                       217184
     C                   ENDSR                                                                217184
      *******************************************************************                     217184
      * Convert a day number into a date                                                      217184
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *************************************************21******************                   217184
      * Convert a date into a day number               21                                     217184
      ********************************************************************                    217184
     C     ZDATE1        BEGSR                                                                217184
     C                   CALLB     'ZDATE1'                                                   217184
     C                   PARM                    ZDATEI            6                          217184
     C                   PARM      *ZEROS        ZDAYNO            5 0                        217184
     C                   PARM                    BJDFIN                                       217184
     C                   PARM      'N'           ErrorFlag         1                          217184
     C                   ENDSR                                                                217184
      *********************************************************************                   217184
      /SPACE 5
      *****************************************************************
      * Edit a signed field
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM                    ZOUT21           21
     C     ZOUT21Sign    IFEQ      '-'
     C                   MOVE      'CR'          ZOUT21Edit
     C                   ELSE
     C                   MOVE      '  '          ZOUT21Edit
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
     C     EXT_LINES     BEGSR
 
     C                   CALLB     'MXEXTRISL'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
 
     C                   PARM      BRCA          P_BRCA            3
     C**********         PARM      CNUM          P_CNUM            6 0                        CSD027
     C                   PARM      CNUM          P_CNUM            6                          CSD027
     C                   PARM      CCY           P_CCY             3
     C**********         PARM      ACOD          P_ACOD            4 0                        CGL029
     C                   PARM      ACOD          P_ACOD           10 0                        CGL029
     C                   PARM      ACSQ          P_ACSQ            2 0
 
     C                   PARM      DACO          P_DACO            5 0
     C                   PARM      HISD          P_HISD            5 0
 
     C                   PARM                    DRCRIN            1
      * credit
     C                   PARM      PCID          P_LCID            5 0
     C                   PARM      CAIC          P_CAIC           15 0
     C                   PARM      CRIP          P_CRIP           15 0
     C                   PARM      CRIS          P_CRIS           15 0
     C                   PARM      TMACI         P_TMACI          15 0
     C                   PARM      PMACI         P_PMACI          15 0
     C                   PARM      *ZERO         P_CTNODYS         5 0
     C                   PARM      *ZERO         P_CTINT          15 0
      * debit
     C                   PARM      PDID          P_LDID            5 0
     C                   PARM      DAIC          P_DAIC           15 0
     C                   PARM      DRIP          P_DRIP           15 0
     C                   PARM      DRIS          P_DRIS           15 0
     C                   PARM      TMADI         P_TMADI          15 0
     C                   PARM      PMADI         P_PMADI          15 0
     C                   PARM      *ZERO         P_DTNODYS         5 0
     C                   PARM      *ZERO         P_DTINT          15 0
 
     C                   PARM      *ZERO         P_SEQN            5 0
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXTRISL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   CALL      'Y2SNMGC'                            0909    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'REUSRMSG'    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
      * Requested Account ID
     C**********         PARM                    I_RACCID         18                          CGL029
     C                   PARM                    I_RACCID         24                          CGL029
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'RE100454 '   DDPGM
 
      * Set up subfile message queue information
 
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access Retail Details
 
     C                   CALL      'AORETLR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
                                                                                              217184
      * Check if CRE001 is installed                                                          217184
                                                                                              217184
     C                   Movel     'N'           CRE001            1                          217184
     C                   Movel     '0'           CRE001            1                          217184
     C                   CALL      'AOSARDR0'                                                 217184
     C                   PARM      '       '     PRTCD             7                          217184
     C                   PARM      '*VERIFY'     POPTN             7                          217184
     C                   PARM      'CRE001'      PSARD             6                          217184
     C     PRTCD         IFEQ      *blanks                                                    217184
     C                   Move      'Y'           CRE001                                       217184
     C                   Seton                                        57                      217184
     C                   Endif                                                                217184
                                                                                            MD046682
      * Check if CRE008 is installed                                                        MD046682
                                                                                            MD046682
     C                   CALL      'AOSARDR0'                                               MD046682
     C                   PARM      '       '     PRTCD                                      MD046682
     C                   PARM      '*VERIFY'     POPTN                                      MD046682
     C                   PARM      'CRE008'      PSARD                                      MD046682
     C     PRTCD         IFEQ      *blanks                                                  MD046682
     C                   Seton                                        20                    MD046682
     C                   Endif                                                              MD046682
 
     C     *DTAARA       DEFINE                  SDSTAT
     C     *LOCK         IN        SDSTAT
     C                   OUT       SDSTAT
 
      * Execute CRTDUPOBJ
 
     C                   MOVEA     LIBR          #_CRTD(33)
     C                   Z-ADD     68            #MesLen          15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_CRTD
     C                   PARM                    #MesLen
 
      * Execute OVRDBFs
 
     C                   Z-ADD     55            #MesLen          15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_OVR1
     C                   PARM                    #MesLen
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_OVR2
     C                   PARM                    #MesLen
 
      * Execute CLRPFM
 
     C                   Z-ADD     27            #MesLen
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_CLR
     C                   PARM                    #MesLen
 
     C                   OPEN      MXRISLPD
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      * key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RISLK         KLIST
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C*                                                                                       217184
     C     DCKEY         KLIST                                                                217184
     C                   KFLD                    BRC                                          217184
     C                   KFLD                    CUS                                          217184
     C                   KFLD                    CCY                                          217184
     C                   KFLD                    ACD                                          217184
     C                   KFLD                    ASN                                          217184
     C                   KFLD                    KDATE             5 0                        217184
                                                                                              217184
     C     *LIKE         DEFINE    R_HISB        ZITHR                                        217184
     C     *LIKE         DEFINE    R_HISB        DINT                                         217184
     C     *LIKE         DEFINE    R_HISB        CINT                                         217184
     C     *LIKE         DEFINE    R_HISB        CINT                                         217184
     C     *LIKE         DEFINE    R_RCA         ZINTR                                        217184
     C     *LIKE         DEFINE    R_HISB        ZIAMT                                        217184
     C     *LIKE         DEFINE    R_HISB        ZBAL                                         217184
     C     *LIKE         DEFINE    R_HISB        ZIAMTR                                       217184
     C     *LIKE         DEFINE    R_HISB        ZIAMT1                                       217184
     C     *LIKE         DEFINE    BJRDNB        ZIREM                                        217184
     C     *LIKE         DEFINE    BJRDNB        ZLDTM                                        217184
     C     *LIKE         DEFINE    BJRDNB        ZIBW1                                        217184
     C     *LIKE         DEFINE    BJRDNB        ZIBEG                                        217184
     C     *LIKE         DEFINE    BJRDNB        ZIEND                                        217184
     C     *LIKE         DEFINE    BJRDNB        ZIDREC                                       217184
     C     *LIKE         DEFINE    BJRDNB        ZIDW2                                        217184
     C     *LIKE         DEFINE    BJRDNB        ZID1                                         217184
     C     *LIKE         DEFINE    BJRDNB        ZID2                                         217184
     C     *LIKE         DEFINE    BJRDNB        ZILPCP                                       217184
     C     *LIKE         DEFINE    BJRDNB        ZIDREM                                       217184
     C     *LIKE         DEFINE    DRIB          ZICT                                         217184
     C     *LIKE         DEFINE    XDRIS         ZIRATE                                       217184
     C     *LIKE         DEFINE    DRIC          ZICALC                                       217184
     C     *LIKE         DEFINE    ACSQ          Y                                            217184
     C     *LIKE         DEFINE    ACSQ          Z                                            217184
     C     *LIKE         DEFINE    ACSQ          ZIDW1                                        217184
     C     *LIKE         DEFINE    ACSQ          ZIMAN                                        217184
     C     *LIKE         DEFINE    ACSQ          ZIM1                                         217184
     C     *LIKE         DEFINE    ACSQ          ZIY1                                         217184
     C                   Z-ADD     0             ZDAYN2            9 4                        217184
     C                   Z-ADD     0             ZIWRK1           15 5                        217184
     C                   Z-ADD     0             INST              5 0                        217184
                                                                                              217184
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** #_CRTD
CRTDUPOBJ OBJ(MXRISLPD) FROMLIB(xxDPLIB) OBJTYPE(*FILE) TOLIB(QTEMP)
** #_OVR1
OVRDBF FILE(MXRISLPD) TOFILE(QTEMP/MXRISLPD) SHARE(*NO)
** #_OVR2
OVRDBF FILE(REHISL) TOFILE(REHISL) SHARE(*NO)
** #_CLR
CLRPFM FILE(QTEMP/MXRISLPD)
