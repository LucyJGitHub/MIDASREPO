     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Extract Retail Interest Statement Lines')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXTRISL - Extract Retail Interest Statement Lines          *
      *                                                               *
      *  Function:  This module extracts retail interest statement    *
      *             lines                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. BUG6417            Date 28Mar05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008             Date 19Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003  *CREATE    Data 21Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6417- Cash management components are missing in MidasPlus *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FREHISL    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(REHISPMF)
     FREHRCJ    IF   E           K DISK    INFSR(*PSSR)
     FREHRDJ    IF   E           K DISK    INFSR(*PSSR)
     FREHPOPL   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REHPOSPF:REHPOPLF)
     F*MXRISLPD*O****E             DISK    INFSR(*PSSR)                         CRE008
     FMXRISLPD  O  A E             DISK    INFSR(*PSSR)                         CRE008
     F                                     PREFIX(O_)
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D RISLX         E DS                  EXTNAME(MXRISLPD)
     D                                     PREFIX(O_)
 
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
 
     D                 DS
     D  SRES                   1      6  0
     D  ZISD                   1      2  0
     D  ZISM                   3      4  0
     D  ZISY                   5      6  0
 
     D                 DS
     D  FRES                   1      6  0
     D  ZIFD                   1      2  0
     D  ZIFM                   3      4  0
     D  ZIFY                   5      6  0
     D*P_ACOD**********S             10S 0                                            CGL029 BUG6417
 
     IREHISPSF
     I              RECI                        D_RECI
     I              HISD                        D_HISD
     I              HISB                        S_HISB
 
     I              DRCB                        S_DRCB
     I              DRIR                        S_DRIR
     I              DRCD                        S_DRCD
     I              DAIC                        S_DAIC
     I              PMADI                       S_PMADI
     I              TMADI                       S_TMADI
     I              PDID                        S_PDID
     I              DMINT                       S_DMINT
     I              DRIP                        S_DRIP
     I              DRIS                        S_DRIS
 
     I              CRCB                        S_CRCB
     I              CRIR                        S_CRIR
     I              CRCD                        S_CRCD
     I              CAIC                        S_CAIC
     I              PMACI                       S_PMACI
     I              TMACI                       S_TMACI
     I              PCID                        S_PCID
     I              CMINT                       S_CMINT
     I              CRIP                        S_CRIP
     I              CRIS                        S_CRIS
 
     I              STBL                        S_STBL
 
     IREHISPPF
     I              RECI                        D_RECI
     I              HISD                        D_HISD
     I              HISB                        D_HISB
 
     I              DMVT                        D_DMVT
     I              DRCB                        D_DRCB
     I              DRIR                        D_DRIR
     I              DRCD                        D_DRCD
     I              DAID                        D_DAID
     I              MADI                        D_MADI
     I              TMADI                       D_TMADI
     I              PDID                        D_PDID
     I              DMINT                       D_DMINT
 
     I              CMVT                        D_CMVT
     I              CRCB                        D_CRCB
     I              CRIR                        D_CRIR
     I              CRCD                        D_CRCD
     I              CAID                        D_CAID
     I              MACI                        D_MACI
     I              TMACI                       D_TMACI
     I              PCID                        D_PCID
     I              CMINT                       D_CMINT
 
     I              DICI                        D_DICI
     I              CICI                        D_CICI
     I              DRCI                        D_DRCI
     I              CRCI                        D_CRCI
 
     C                   CLEAR                   RISLX
 
     C                   MOVE      P_BRCA        O_BRCA
     C                   MOVE      P_CNUM        O_CNUM
     C                   MOVE      P_CCY         O_CCY
     C                   MOVE      P_ACOD        O_ACOD
     C                   MOVE      P_ACSQ        O_ACSQ
     C                   MOVE      DRCRIN        O_DRCRIN
 
     C     DRCRIN        IFEQ      'C'
     C                   EXSR      CRSR
     C                   ELSE
     C                   EXSR      DRSR
     C                   ENDIF
 
     C                   Z-ADD     O_SEQN        P_SEQN
 
     C                   SETON                                        LR        CRE008
     C                   RETURN
 
      ********************************************************************
     C     CRSR          BEGSR
 
      **  Get first REHISL record as at LAST CREDIT CAPITALISATION DATE
 
     C                   EXSR      GET_1stRCR
 
      *  PREPARE B/F BALANCE AND OPENING BALANCES
 
     C     D_RECI        IFEQ      'B'
     C                   Z-ADD     D_HISD        P_LCID
     C                   Z-ADD     D_HISB        OpenBal
     C                   EXSR      BFOPSR
     C                   Z-ADD     OpenBal       BFwdBal
     C                   ELSE
     C     D_RECI        IFEQ      'S'
     C                   Z-ADD     S_STBL        BFwdBal
     C                   Z-ADD     S_HISB        OpenBal
     C                   END
     C                   END
      *
      **  OUTPUT B/F BALANCE
      **  ------------------
      *
     C                   MOVEL     'B'           O_RECTYP
     C                   Z-ADD     P_LCID        O_SDATE
     C                   Z-ADD     BFwdBal       O_ACBAL
     C                   ADD       1             O_SEQN
     C                   WRITE     MXRISLP0
      *
      ** OUTPUT OPENING BALANCE & RATE
      ** -----------------------------
      *
     C                   MOVEL     'O'           O_RECTYP
     C                   Z-ADD     P_LCID        O_SDATE
     C                   Z-ADD     OpenBal       O_ACBAL
 
     C     klistLCID     SETLL     REHRCJ
     C     P_LCID        IFEQ      P_DACO
     C     klistLCID     READE     REHRCJ                                 99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     0             INRT
     C                   END
     C                   ELSE
     C     klist         READPE    REHRCJ                                 99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     0             INRT
     C                   END
     C                   END
     C                   Z-ADD     INRT          O_INTRT
 
     C                   ADD       1             O_SEQN
     C                   WRITE     MXRISLP0
 
      ** LOOP THROUGH ALL HISTORY RECORDS UP TO THE CURRENT HISTORY DATE
 
     C     *IN51         DOWEQ     '0'
     C     D_HISD        ANDLT     P_HISD
      *
      **  SAVE REHISL  AS PREVIOUS
      *
     C     D_RECI        IFEQ      'B'
     C     D_RECI        OREQ      'D'
     C                   Z-ADD     D_HISD        WW_HISD
     C                   Z-ADD     D_HISB        WW_HISB
 
     C                   MOVE      D_DRCB        WW_DRCB
     C                   Z-ADD     D_DRIR        WW_DRIR
     C                   Z-ADD     D_DRCD        WW_DRCD
     C                   Z-ADD     D_DAID        WW_DAID
     C                   Z-ADD     D_MADI        WW_MADI
     C                   Z-ADD     D_TMADI       WW_TMADI
     C                   Z-ADD     D_PDID        WW_PDID
     C                   Z-ADD     D_DMINT       WW_DMINT
 
     C                   Z-ADD     D_CRCB        WW_CRCB
     C                   Z-ADD     D_CRIR        WW_CRIR
     C                   Z-ADD     D_CRCD        WW_CRCD
     C                   Z-ADD     D_CAID        WW_CAID
     C                   Z-ADD     D_MACI        WW_MACI
     C                   Z-ADD     D_TMACI       WW_TMACI
     C                   Z-ADD     D_PCID        WW_PCID
     C                   Z-ADD     D_CMINT       WW_CMINT
 
     C                   MOVE      D_DICI        WW_DICI
     C                   MOVE      D_CICI        WW_CICI
     C                   MOVE      D_DRCI        WW_DRCI
     C                   MOVE      D_CRCI        WW_CRCI
      *
     C                   ELSE
 
     C                   Z-ADD     D_HISD        WW_HISD
     C                   Z-ADD     S_HISB        WW_HISB
     C                   MOVE      S_CRCB        WW_CRCB
     C                   Z-ADD     S_CRIR        WW_CRIR
     C     SCICI         IFEQ      *BLANK
     C                   Z-ADD     S_CAIC        WW_CAID
     C                   END
     C                   END
 
     C                   EXSR      GET_NxtRCR
 
      ** OUTPUT BALANCE LINE
 
     C     *IN51         IFEQ      '0'
 
     C                   Z-ADD     WW_HISD       O_SDATE
     C                   Z-ADD     D_HISD        O_EDATE
     C                   Z-ADD     WW_HISB       O_ACBAL
 
     C                   Z-ADD     WW_CRCB       ZICALC
     C                   Z-ADD     WW_HISD       ZIBEG
     C                   Z-ADD     D_HISD        ZIEND
     C                   EXSR      ZICD
 
     C     ZDAYN2        IFNE      *ZERO
 
     C                   Z-ADD     ZDAYN2        O_NODYS
 
     C     WW_CRCI       IFEQ      'Y'
     C                   Z-ADD     WW_CRIR       O_INTRT
     C                   ENDIF
 
     C                   MOVEL     WW_CRCB       O_DYBS
 
     C     D_HISD        IFLT      P_HISD
      *
     C     D_RECI        IFEQ      'S'
     C     S_CAIC        SUB       WW_CAID       O_INTACC
     C                   ELSE
     C     D_CAID        SUB       WW_CAID       O_INTACC
     C                   END
      *
     C                   ELSE
     C     P_CRIP        SUB       WW_CAID       O_INTACC
     C                   ADD       P_CRIS        O_INTACC
     C                   ADD       P_CAIC        O_INTACC
     C                   END
 
      ** OUTPUT BALANCE LINE
 
     C                   MOVEL     ' '           O_RECTYP
     C                   ADD       1             O_SEQN
     C                   WRITE     MXRISLP0
     C                   END
     C                   END
      *
     C                   ENDDO
                                                                                CRE008
      ** OUTPUT CLOSING CR BALANCE LINE                                         CRE008
                                                                                CRE008
     C     D_HISD        IFLT      P_HISD                                       CRE008
                                                                                CRE008
     C                   Z-ADD     WW_HISD       O_SDATE                        CRE008
     C                   Z-ADD     P_HISD        O_EDATE                        CRE008
     C                   Z-ADD     WW_HISB       O_ACBAL                        CRE008
     C                   Z-ADD     WW_CRCB       ZICALC                         CRE008
     C                   Z-ADD     WW_HISD       ZIBEG                          CRE008
     C                   Z-ADD     P_HISD        ZIEND                          CRE008
     C                   EXSR      ZICD                                         CRE008
     C                   Z-ADD     ZDAYN2        O_NODYS                        CRE008
     C     WW_CRCI       IFEQ      'Y'                                          CRE008
     C                   Z-ADD     WW_CRIR       O_INTRT                        CRE008
     C                   ENDIF                                                  CRE008
     C                   MOVEL     WW_CRCB       O_DYBS                         CRE008
     C     P_CRIP        SUB       WW_CAID       O_INTACC                       CRE008
     C                   ADD       P_CRIS        O_INTACC                       CRE008
     C                   ADD       P_CAIC        O_INTACC                       CRE008
                                                                                CRE008
     C                   MOVEL     ' '           O_RECTYP                       CRE008
     C                   ADD       1             O_SEQN                         CRE008
     C                   WRITE     MXRISLP0                                     CRE008
                                                                                CRE008
     C                   ENDIF                                                  CRE008
 
      * Total number of days in the CR capitalization period
 
     C                   Z-ADD     WW_CRCB       ZICALC
     C                   Z-ADD     P_LCID        ZIBEG
     C                   Z-ADD     P_HISD        ZIEND
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN2        P_CTNODYS
 
      * Total interest CR capitalisation only.
 
     C     *IN51         IFEQ      '0'
     C                   Z-ADD     P_CRIP        P_CTINT
     C                   ADD       P_CRIS        P_CTINT
     C                   ADD       P_CAIC        P_CTINT
     C     SCICI         IFEQ      ' '
     C                   ADD       P_TMACI       P_CTINT
     C                   ELSE
     C                   ADD       P_PMACI       P_CTINT
     C                   END
     C                   ELSE
     C                   Z-ADD     *ZERO         P_CTINT
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     DRSR          BEGSR
 
      **  Get first REHISL record as at LAST DEBIT CAPITALISATION DATE
 
     C                   EXSR      GET_1stRDR
 
      *  PREPARE B/F BALANCE AND OPENING BALANCES
 
     C     D_RECI        IFEQ      'B'                                          - B1
     C                   Z-ADD     D_HISD        P_LDID
     C                   Z-ADD     D_HISB        OpenBal
     C                   EXSR      BFOPSR
     C                   Z-ADD     OpenBal       BFwdBal
     C                   ELSE                                                   - X1
     C     D_RECI        IFEQ      'S'
     C                   Z-ADD     S_STBL        BFwdBal
     C                   Z-ADD     S_HISB        OpenBal
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
      **  OUTPUT B/F BALANCE
      **  ------------------
      *
     C                   MOVEL     'B'           O_RECTYP
     C                   Z-ADD     P_LDID        O_SDATE
     C                   Z-ADD     BFwdBal       O_ACBAL
     C                   ADD       1             O_SEQN
     C                   WRITE     MXRISLP0
      *
      ** OUTPUT OPENING BALANCE & RATE
      ** -----------------------------
      *
     C                   MOVEL     'O'           O_RECTYP
     C                   Z-ADD     P_LDID        O_SDATE
     C                   Z-ADD     OpenBal       O_ACBAL
 
     C     klistLDID     SETLL     REHRDJ
     C     P_LDID        IFEQ      P_DACO
     C     klistLDID     READE     REHRDJ                                 99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     0             INRT
     C                   END
     C                   ELSE
     C     klist         READPE    REHRDJ                                 99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     0             INRT
     C                   END
     C                   END
     C                   Z-ADD     INRT          O_INTRT
 
     C                   ADD       1             O_SEQN
     C                   WRITE     MXRISLP0
 
      ** LOOP THROUGH ALL HISTORY RECORDS UP TO THE CURRENT HISTORY DATE
 
     C     *IN51         DOWEQ     '0'                                          - B1
     C     D_HISD        ANDLT     P_HISD
      *
      **  SAVE REHISL  AS PREVIOUS
      *
     C     D_RECI        IFEQ      'B'
     C     D_RECI        OREQ      'D'
     C                   Z-ADD     D_HISD        WW_HISD
     C                   Z-ADD     D_HISB        WW_HISB
 
     C                   MOVE      D_DRCB        WW_DRCB
     C                   Z-ADD     D_DRIR        WW_DRIR
     C                   Z-ADD     D_DRCD        WW_DRCD
     C                   Z-ADD     D_DAID        WW_DAID
     C                   Z-ADD     D_MADI        WW_MADI
     C                   Z-ADD     D_TMADI       WW_TMADI
     C                   Z-ADD     D_PDID        WW_PDID
     C                   Z-ADD     D_DMINT       WW_DMINT
 
     C                   Z-ADD     D_CRCB        WW_CRCB
     C                   Z-ADD     D_CRIR        WW_CRIR
     C                   Z-ADD     D_CRCD        WW_CRCD
     C                   Z-ADD     D_CAID        WW_CAID
     C                   Z-ADD     D_MACI        WW_MACI
     C                   Z-ADD     D_TMACI       WW_TMACI
     C                   Z-ADD     D_PCID        WW_PCID
     C                   Z-ADD     D_CMINT       WW_CMINT
 
     C                   MOVE      D_DICI        WW_DICI
     C                   MOVE      D_CICI        WW_CICI
     C                   MOVE      D_DRCI        WW_DRCI
     C                   MOVE      D_CRCI        WW_CRCI
      *
     C                   ELSE
 
     C                   Z-ADD     D_HISD        WW_HISD
     C                   Z-ADD     S_HISB        WW_HISB
     C                   MOVE      S_DRCB        WW_DRCB
     C                   Z-ADD     S_DRIR        WW_DRIR
     C     SDICI         IFEQ      *BLANK
     C                   Z-ADD     S_DAIC        WW_DAID
     C                   END
     C                   END
 
     C                   EXSR      GET_NxtRDR
 
      ** OUTPUT BALANCE LINE
 
     C     *IN51         IFEQ      '0'
 
     C                   Z-ADD     WW_HISD       O_SDATE
     C                   Z-ADD     D_HISD        O_EDATE
     C                   Z-ADD     WW_HISB       O_ACBAL
 
     C                   Z-ADD     WW_DRCB       ZICALC
     C                   Z-ADD     WW_HISD       ZIBEG
     C                   Z-ADD     D_HISD        ZIEND
     C                   EXSR      ZICD
 
     C     ZDAYN2        IFNE      *ZERO
 
     C                   Z-ADD     ZDAYN2        O_NODYS
 
     C     WW_DRCI       IFEQ      'Y'
     C                   Z-ADD     WW_DRIR       O_INTRT
     C                   ENDIF
 
     C                   MOVEL     WW_DRCB       O_DYBS
 
     C     D_HISD        IFLT      P_HISD
      *
     C     D_RECI        IFEQ      'S'
     C     S_DAIC        SUB       WW_DAID       O_INTACC
     C                   ELSE
     C     D_DAID        SUB       WW_DAID       O_INTACC
     C                   END
      *
     C                   ELSE
     C     P_DRIP        SUB       WW_DAID       O_INTACC
     C                   ADD       P_DRIS        O_INTACC
     C                   ADD       P_DAIC        O_INTACC
     C                   END
 
      ** OUTPUT BALANCE LINE
 
     C                   MOVEL     ' '           O_RECTYP
     C                   ADD       1             O_SEQN
     C                   WRITE     MXRISLP0
     C                   END
     C                   END
      *
     C                   ENDDO
                                                                                CRE008
      ** OUTPUT CLOSING DR BALANCE LINE                                         CRE008
                                                                                CRE008
     C     D_HISD        IFLT      P_HISD                                       CRE008
                                                                                CRE008
     C                   Z-ADD     WW_HISD       O_SDATE                        CRE008
     C                   Z-ADD     P_HISD        O_EDATE                        CRE008
     C                   Z-ADD     WW_HISB       O_ACBAL                        CRE008
     C                   Z-ADD     WW_DRCB       ZICALC                         CRE008
     C                   Z-ADD     WW_HISD       ZIBEG                          CRE008
     C                   Z-ADD     P_HISD        ZIEND                          CRE008
     C                   EXSR      ZICD                                         CRE008
     C                   Z-ADD     ZDAYN2        O_NODYS                        CRE008
     C     WW_DRCI       IFEQ      'Y'                                          CRE008
     C                   Z-ADD     WW_DRIR       O_INTRT                        CRE008
     C                   ENDIF                                                  CRE008
     C                   MOVEL     WW_DRCB       O_DYBS                         CRE008
     C     P_DRIP        SUB       WW_DAID       O_INTACC                       CRE008
     C                   ADD       P_DRIS        O_INTACC                       CRE008
     C                   ADD       P_DAIC        O_INTACC                       CRE008
                                                                                CRE008
     C                   MOVEL     ' '           O_RECTYP                       CRE008
     C                   ADD       1             O_SEQN                         CRE008
     C                   WRITE     MXRISLP0                                     CRE008
                                                                                CRE008
     C                   ENDIF                                                  CRE008
 
      * Total number of days in the DR capitalization period
 
     C                   Z-ADD     WW_DRCB       ZICALC
     C                   Z-ADD     P_LDID        ZIBEG
     C                   Z-ADD     P_HISD        ZIEND
     C                   EXSR      ZICD
 
     C                   Z-ADD     ZDAYN2        P_DTNODYS
 
      * Total interest DR capitalisation only.
 
     C     *IN51         IFEQ      '0'
     C                   Z-ADD     P_DRIP        P_DTINT
     C                   ADD       P_DRIS        P_DTINT
     C                   ADD       P_DAIC        P_DTINT
     C     SDICI         IFEQ      ' '
     C                   ADD       P_TMADI       P_DTINT
     C                   ELSE
     C                   ADD       P_PMADI       P_DTINT
     C                   END
     C                   ELSE
     C                   Z-ADD     *ZERO         P_DTINT
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     BFOPSR        BEGSR
     C*
     C     klistDHISD    CHAIN     REHPOPL                            99
     C     *IN99         DOWEQ     '0'
     C     DRCR          IFEQ      0
     C                   SUB       PSTA          OpenBal
     C                   ELSE
     C                   ADD       PSTA          OpenBal
     C                   END
     C     klistDHISD    READE     REHPOPL                                99
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     GET_1stRCR    BEGSR
 
     C     klistLCID     SETLL     REHISL
      *
     C     klist         READE     REHISL                                 51
 
      * If a/c header or cap. rec. not found, read the previous record
      * as if demand or closure cap.
 
     C     *IN51         IFEQ      '1'
     C     D_RECI        ORNE      'B'
     C     D_RECI        ANDNE     'S'
     C                   SUB       1             P_LCID
     C     klistLCID     SETLL     REHISL
     C     klist         READE     REHISL                                 51
     C                   END
 
     C     *IN51         DOWEQ     '0'
     C     D_RECI        ANDEQ     'S'
     C     SDICI         ANDNE     *BLANKS
     C     SCICI         ANDEQ     *BLANKS
     C     D_HISD        ANDLT     P_HISD
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_MADI        ANDNE     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_DRCI        ANDEQ     'Y'
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_DRCI        ANDEQ     'Y'
     C     D_MADI        ANDNE     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
 
     C     klist         READE     REHISL                                 51
 
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     GET_NxtRCR    BEGSR
 
     C     klist         READE     REHISL                                 51
 
     C     *IN51         DOWEQ     '0'
     C     D_RECI        ANDEQ     'S'
     C     SDICI         ANDNE     *BLANKS
     C     SCICI         ANDEQ     *BLANKS
     C     SGADI         ANDEQ     *ZEROS
     C     D_HISD        ANDLT     P_HISD
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_MADI        ANDNE     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_DRCI        ANDEQ     'Y'
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_DRCI        ANDEQ     'Y'
     C     D_MADI        ANDNE     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
 
     C     klist         READE     REHISL                                 51
 
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     GET_1stRDR    BEGSR
 
     C     klistLDID     SETLL     REHISL
      *
     C     klist         READE     REHISL                                 51
      *
      * If a/c header or cap. rec. not found, read the previous record
      * as if demand or closure cap.
 
     C     *IN51         IFEQ      '1'
     C     D_RECI        ORNE      'B'
     C     D_RECI        ANDNE     'S'
     C                   SUB       1             P_LDID
     C     klistLDID     SETLL     REHISL
     C     klist         READE     REHISL                                 51
     C                   END
 
     C     *IN51         DOWEQ     '0'                                          - B1
     C     D_RECI        ANDEQ     'S'
     C     SCICI         ANDNE     *BLANKS
     C     SDICI         ANDEQ     *BLANKS
     C     D_HISD        ANDLT     P_HISD
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDNE     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     'Y'
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     'Y'
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDNE     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
 
     C     klist         READE     REHISL                                 51
 
     C                   END                                                    - E1
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     GET_NxtRDR    BEGSR
 
     C     klist         READE     REHISL                                 51
 
     C     *IN51         DOWEQ     '0'                                          - B2
     C     D_RECI        ANDEQ     'S'
     C     SCICI         ANDNE     *BLANKS
     C     SDICI         ANDEQ     *BLANKS
     C     SGACI         ANDEQ     *ZEROS
     C     D_HISD        ANDLT     P_HISD
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDNE     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     'Y'
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     'Y'
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDNE     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
     C     *IN51         OREQ      '0'
     C     D_RECI        ANDEQ     'D'
     C     D_DRCI        ANDEQ     *BLANKS
     C     D_CRCI        ANDEQ     *BLANKS
     C     D_MADI        ANDEQ     *ZEROS
     C     D_MACI        ANDEQ     *ZEROS
     C     D_DMVT        ANDEQ     *ZEROS
     C     D_CMVT        ANDEQ     *ZEROS
 
     C     klist         READE     REHISL                                 51
 
     C                   END                                                    - E2
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     ZICD          BEGSR                                                  **ZICD BEGSR**
     C*
     C** TO DETERMINE NUMBER OF DAYS INTEREST TO BE CALCULATED
     C*
     C     ZIEND         SUB       ZIBEG         ZDAYN2
     C*
     C** CHECK FOR INTEREST CALCULATION BASIS
     C*
     C     ZICALC        IFEQ      3                                            - B1
     C     ZIEND         IFGT      ZIBEG                                        - B2
     C*
     C** CALCULATING DATE FROM DAY NUMBER (BEGINNING DATE)
     C*
     C                   Z-ADD     ZIBEG         ZDAYNO
     C                   EXSR      ZDATE2
     C*
     C                   Z-ADD     ZDATE         SRES
     C*
     C** CALCULATING DATE FROM DAY NUMBER (FINISHING DATE)
     C*
     C                   Z-ADD     ZIEND         ZDAYNO
     C                   EXSR      ZDATE2
     C*
     C                   Z-ADD     ZDATE         FRES
     C*
     C** IN ORDER FOR THE FINISH YEAR TO BE LESS THAN THE START YEAR IF ZIEND
     C** IS GREATER THAN ZIBEG, THEN THE DATE ZIEND MUST BE IN A DIFFERENT
     C** CENTURY TO ZIBEG. IF SO ADD 100 YEARS TO IT.
     C*
     C     ZIFY          IFLT      ZISY                                         - B3
     C     ZIFY          ADD       100           ZIFY2             3 0
     C                   ELSE                                                   - X3
     C                   Z-ADD     ZIFY          ZIFY2
     C                   END                                                    - E3
     C*
     C                   Z-ADD     ZISY          ZISY2             3 0
     C*
     C** DETERMINE WHETHER START YEAR IS A LEAP YEAR AND IF START MONTH
     C** IS FEBRUARY  THEN CONSIDER LAST DAY OF FEBRUARY AS DATE 30ND. OF THE
     C** MONTH
     C*
     C     ZISM          IFEQ      2                                            - B3
     C     ZISY2         ADD       1900          ZLYCHK            4 0
     C     ZLYCHK        DIV       4             ZLYCHK
     C                   MVR                     ZLYREM            2 0
     C     ZLYREM        IFEQ      0                                            - B4
     C     ZISD          IFEQ      29                                           - B5
     C                   Z-ADD     30            ZISD
     C                   END                                                    - E5
     C                   ELSE                                                   - X4
     C     ZISD          IFEQ      28                                           - B5
     C                   Z-ADD     30            ZISD
     C                   END                                                    - E5
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*
     C     30            SUB       ZISD          ZID1
     C*
     C     ZID1          IFLT      0                                            - B3
     C                   Z-ADD     *ZEROS        ZID1
     C                   END                                                    - E3
     C*
     C     ZISM          IFEQ      12                                           - B3
     C                   Z-ADD     *ZEROS        ZISM
     C                   ADD       1             ZISY
     C                   ADD       1             ZISY2
     C                   END                                                    - E3
     C*
     C** DETERMINE WHETHER END YEAR IS A LEAP YEAR AND IF END MONTH IS FEBRUARY
     C*
     C     ZIFM          IFEQ      2                                            - B3
     C     ZIFY2         ADD       1900          ZLYCHK            4 0
     C     ZLYCHK        DIV       4             ZLYCHK
     C                   MVR                     ZLYREM            2 0
     C     ZLYREM        IFEQ      0                                            - B4
     C     ZIFD          IFEQ      29                                           - B5
     C                   Z-ADD     30            ZIFD
     C                   END                                                    - E5
     C                   ELSE                                                   - X4
     C     ZIFD          IFEQ      28                                           - B5
     C                   Z-ADD     30            ZIFD
     C                   END                                                    - E5
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*
     C     ZIFD          IFEQ      31                                           - B3
     C                   ADD       30            ZID1
     C                   ELSE                                                   - X3
     C                   ADD       ZIFD          ZID1
     C                   END                                                    - E3
     C*
     C                   SUB       1             ZIFM
     C*
     C     ZISY          IFEQ      ZIFY                                         - B3
     C     ZIFM          SUB       ZISM          ZINOM             3 0
     C                   ELSE                                                   - X3
     C     12            SUB       ZISM          ZIM1
     C                   Z-ADD     1             ZISM
     C*
     C** USE ENLARGE FIELDS THAT CAN HANDLE 1999 ONWARDS
     C*
     C                   ADD       1             ZISY2
     C     ZIFY2         SUB       ZISY2         ZIY1
     C     ZIY1          MULT      12            ZIM2              3 0
     C     ZIM2          ADD       ZIFM          ZIM2
     C     ZIM2          ADD       ZIM1          ZINOM
     C*
     C                   END                                                    - E3
     C*
     C     ZINOM         MULT      30            ZID2
     C     ZID2          ADD       ZID1          ZDAYN2
     C*
     C                   END                                                    - E2
     C*
     C                   END                                                    - E1
     C*
     C     ZICALC        IFEQ      4                                            - B1
     C     ZICALC        OREQ      5
     C*
     C** ONE DAY IS SUBTRACTED FROM ZDAYN2 FOR EACH OCCURANCE OF 29 FEB IN THE
     C** THE INTEREST CALCULATION PERIOD INCLUSIVE OF ZIBEG AND ZIEND
     C*
     C** FIND NO OF FOUR YEAR PERIODS BETWEEN DATES
     C*
     C     ZDAYN2        DIV       1461          ZIMAN
     C                   MVR                     ZIREM
     C*
     C** FIND NEXT 29 FEB DAY NO. ON OR AFTER ZIBEG.
     C*
     C     ZIBEG         SUB       60            ZIBW1
     C     ZIBW1         DIV       1461          ZIDW1
     C                   MVR                     ZIDREM
     C*
     C     ZIDREM        IFEQ      0                                            - B2
     C                   Z-ADD     ZIBEG         ZIDW2
     C                   END                                                    - E2
     C*
     C** ROUND UP RESULT
     C*
     C     ZIDW1         ADD       1             ZIDW2
     C*
     C** CALCULATE NEXT 29 FEB.
     C*
     C     ZIDW2         MULT      1461          ZIDW2
     C     ZIDW2         ADD       60            ZIDW2
     C*
     C** IF THIS NEXT 29 FEB. DAYNO - ZIBEG IS GREATER OR EQUAL TO ZIREM THEN
     C** ADD 1 TO ZIMAN.
     C*
     C     ZIDW2         SUB       ZIBEG         ZILPCP
     C*
     C     ZIREM         IFGE      ZILPCP                                       - B2
     C                   ADD       1             ZIMAN
     C                   END                                                    - E2
     C*
     C** SUBTRACT ZIMAN FROM ZDAYN2 TO GIVE VALUE OF ZDAYN2 REQUIRED FOR THIS
     C** INTEREST CALCULATION
     C*
     C     ZDAYN2        SUB       ZIMAN         ZDAYN2
     C*
     C                   END                                                    - E1
     C*
     C                   ENDSR                                                  **ZICD ENDSR**
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     ZDATE2        BEGSR
     C**
     C**   CLEAR LEAP YEAR WORK FIELD.
     C                   MOVE      'N'           ZLEAP             1
     C**
     C**   CLEAR DATE FIELDS.
     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7
     C**
     C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C**
     C**   DETERMINE YEAR NUMBER.
     C**
     C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
     C     ZDAYNO        SUB       1             ZDAYN1            5 0
     C     ZDAYN1        IFLT      0
     C                   GOTO      ZDEND2
     C                   END
     C**
     C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1                         SAVE REMAINING
     C**                                                   DAYS
     C**   CALCULATE NUMBER OF REMAINING YEARS.
     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
     C     ZDAYN1        IFGE      ZYDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG1
     C                   END
     C*
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
     C     ZWRK2         IFNE      0
     C     ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C                   END
     C**
     C**   CALCULATE ACTUAL YEAR NUMBER.
     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
     C**
     C**   DETERMINE MONTH NUMBER.
     C**
     C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
     C     ZWRK2         IFEQ      0
     C     ZDAYN1        IFEQ      59
     C                   MOVE      'Y'           ZLEAP
     C                   END
     C     ZDAYN1        IFGE      59
     C     ZDAYN1        SUB       1             ZDAYN1
     C                   END
     C                   END
     C**
     C**   CALCULATE MONTH NUMBER.
     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
     C     ZDAYN1        IFGE      ZMDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG2
     C                   END
     C*
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
     C**
     C**   DETERMINE DAY OF MONTH.
     C**
     C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
     C     ZDAYN1        ADD       1             ZDAYN1
     C**
     C**   CALCULATE DAY OF MONTH.
     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
     C**
     C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
     C     ZLEAP         IFEQ      'Y'
     C     ZDAY          ADD       1             ZDAY
     C                   END
     C**
     C**   FORMAT DATE, DDMMYY OR MMDDYY.
     C  N98              MOVEL     ZDAY          ZWRK4             4 0
     C   98              MOVE      ZDAY          ZWRK4
     C  N98              MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C**
     C**   FORMAT ALPHA DATE, DDMMMYY.
     C                   MOVEL     ZDAY          ZWRK5             5
     C     ZDAY          IFLT      10
     C                   MOVEL     ' '           ZWRK5
     C                   END
     C                   MOVE      ZMNM(ZMTH)    ZWRK5
     C                   MOVEL     ZWRK5         ZADATE
     C                   MOVE      ZYEAR         ZADATE
     C**
     C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
     C                   PARM                    P_BRCA            3
     C**********         PARM                    P_CNUM            6 0                        CSD027
     C                   PARM                    P_CNUM            6                          CSD027
     C                   PARM                    P_CCY             3
     C**********         PARM                    P_ACOD            4 0                        CGL029
     C**********         PARM                    P_ACOD                               CGL029 BUG6417
     C                   PARM                    P_ACOD           10 0                       BUG6417
     C                   PARM                    P_ACSQ            2 0
 
     C                   PARM                    P_DACO            5 0
     C                   PARM                    P_HISD            5 0
 
     C                   PARM                    DRCRIN            1
      * credit
     C                   PARM                    P_LCID            5 0
     C                   PARM                    P_CAIC           15 0
     C                   PARM                    P_CRIP           15 0
     C                   PARM                    P_CRIS           15 0
     C                   PARM                    P_TMACI          15 0
     C                   PARM                    P_PMACI          15 0
     C                   PARM                    P_CTNODYS         5 0
     C                   PARM                    P_CTINT          15 0
      * debit
     C                   PARM                    P_LDID            5 0
     C                   PARM                    P_DAIC           15 0
     C                   PARM                    P_DRIP           15 0
     C                   PARM                    P_DRIS           15 0
     C                   PARM                    P_TMADI          15 0
     C                   PARM                    P_PMADI          15 0
     C                   PARM                    P_DTNODYS         5 0
     C                   PARM                    P_DTINT          15 0
 
     C                   PARM                    P_SEQN            5 0
 
     C                   MOVE      '0'           *in98
 
     C     *LIKE         DEFINE    D_CAID        WW_CAID
     C     *LIKE         DEFINE    D_CICI        WW_CICI
     C     *LIKE         DEFINE    D_CMINT       WW_CMINT
     C     *LIKE         DEFINE    D_CRCB        WW_CRCB
     C     *LIKE         DEFINE    D_CRCD        WW_CRCD
     C     *LIKE         DEFINE    D_CRCI        WW_CRCI
     C     *LIKE         DEFINE    D_CRIR        WW_CRIR
     C     *LIKE         DEFINE    D_DAID        WW_DAID
     C     *LIKE         DEFINE    D_DICI        WW_DICI
     C     *LIKE         DEFINE    D_DMINT       WW_DMINT
     C     *LIKE         DEFINE    D_DRCB        WW_DRCB
     C     *LIKE         DEFINE    D_DRCD        WW_DRCD
     C     *LIKE         DEFINE    D_DRCI        WW_DRCI
     C     *LIKE         DEFINE    D_DRIR        WW_DRIR
     C     *LIKE         DEFINE    D_HISB        WW_HISB
     C     *LIKE         DEFINE    D_HISD        WW_HISD
     C     *LIKE         DEFINE    D_MACI        WW_MACI
     C     *LIKE         DEFINE    D_MADI        WW_MADI
     C     *LIKE         DEFINE    D_PCID        WW_PCID
     C     *LIKE         DEFINE    D_PDID        WW_PDID
     C     *LIKE         DEFINE    D_TMACI       WW_TMACI
     C     *LIKE         DEFINE    D_TMADI       WW_TMADI
 
     C     *LIKE         DEFINE    D_HISB        OpenBal
     C     *LIKE         DEFINE    D_HISB        BFwdBal
 
     C                   Z-ADD     *ZEROS        ZICALC            2 0
     C                   Z-ADD     *ZEROS        ZDAYN2            9 4
     C     *LIKE         DEFINE    BJRDNB        ZIBEG
     C     *LIKE         DEFINE    BJRDNB        ZIBW1
     C     *LIKE         DEFINE    BJRDNB        ZIDREM
     C     *LIKE         DEFINE    CICT          ZIDW1
     C     *LIKE         DEFINE    BJRDNB        ZIDW2
     C     *LIKE         DEFINE    BJRDNB        ZID1
     C     *LIKE         DEFINE    BJRDNB        ZID2
     C     *LIKE         DEFINE    BJRDNB        ZIEND
     C     *LIKE         DEFINE    BJRDNB        ZILPCP
     C     *LIKE         DEFINE    CICT          ZIMAN
     C     *LIKE         DEFINE    CICT          ZIM1
     C     *LIKE         DEFINE    BJRDNB        ZIREM
     C     *LIKE         DEFINE    CICT          ZIY1
 
      **  KLIST TO CHAIN ON REHPOPH & REHPOPL
 
     C     klist         KLIST
     C                   KFLD                    O_BRCA
     C                   KFLD                    O_CNUM
     C                   KFLD                    O_CCY
     C                   KFLD                    O_ACOD
     C                   KFLD                    O_ACSQ
 
      **  KLIST TO READ REHISL FOR DEBIT
 
     C     klistLDID     KLIST
     C                   KFLD                    O_BRCA
     C                   KFLD                    O_CNUM
     C                   KFLD                    O_CCY
     C                   KFLD                    O_ACOD
     C                   KFLD                    O_ACSQ
     C                   KFLD                    P_LDID
 
      **  KLIST TO READ REHISL FOR CREDIT
 
     C     klistLCID     KLIST
     C                   KFLD                    O_BRCA
     C                   KFLD                    O_CNUM
     C                   KFLD                    O_CCY
     C                   KFLD                    O_ACOD
     C                   KFLD                    O_ACSQ
     C                   KFLD                    P_LCID
 
      **  KLIST TO CHAIN ON REHISSL
 
     C     klistDHISD    KLIST
     C                   KFLD                    O_BRCA
     C                   KFLD                    O_CNUM
     C                   KFLD                    O_CCY
     C                   KFLD                    O_ACOD
     C                   KFLD                    O_ACSQ
     C                   KFLD                    D_HISD
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
