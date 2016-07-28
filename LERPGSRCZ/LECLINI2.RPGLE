     H DEBUG
     H COPYRIGHT('(C) Copyright Midas-Kapiti International Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Set class on transactions')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  LECLINI2 - Set class on transactions                         *
      *             (Lending initialisation program)                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE154             Date 06Aug12               *
      *  Prev Amend No. CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE147             Date 30Sep11               *
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
      *                 CSD027A            Date 03May06               *
      *                 CLE042  *CREATE    Date 06Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CLE042 - Extended Loan Sub Type                              *
      *                                                               *
      *****************************************************************

     FSDTCLDPD  IP   E             DISK

     FCLOANCL   UF   E             DISK
     FMCLONCL   UF   E             DISK    RENAME(CLOANCLF:MCLONCLF)

     FFCLTYFM   UF   E             DISK
     FLEFCLTQD  UF   E             DISK

     FLEAGFMPD  UF   E             DISK    RENAME(FCLTYFMF:LEAGFMF)
     FLEAGFTQD  UF   E             DISK    RENAME(LEFCLTD0:LEAGFTD0)

     FLEFEED    UF   E             DISK

     FLEPARTPD  UF   E             DISK

     FLOAMSDK   UF   E             DISK

     FLEPELND   UF   E             DISK
     FLEPEMGD   UF   E             DISK

     FLENPVAPD  UF   E             DISK
     FLENPVLPD  UF   E             DISK
     FLEHNPAPD  UF   E             DISK    RENAME(LENPVAD0:LEHNPVAD0)
     FLEHNPLPD  UF   E             DISK    RENAME(LENPVLD0:LEHNPVLD0)

     FHISTSHM   UF   E             DISK
     FHISTSHP   UF   E             DISK
     FMHISTHM   UF   E             DISK    RENAME(HISTSHMF:MHISTHMF)
     FMHISTHP   UF   E             DISK    RENAME(HISTSHPF:MHISTHPF)

     FQSYSPRT   O    F  132        PRINTER USROPN


     ILEFEEDF
     I              FESUTP                      SUTP
     I              FECLAS                      CLAS

     ILEFCLTD0
     I              FCXSLS                      SLST
     I              FCXSLC                      SLCL
     I              FCXRLS                      DRST
     I              FCXRLC                      DRCL

     ILEAGFTD0
     I              FCXSLS                      SLST
     I              FCXSLC                      SLCL
     I              FCXRLS                      DRST
     I              FCXRLC                      DRCL

     ILEPELNDF
     I              LDSUTP                      SUTP
     I              LDCLAS                      CLAS

     ILEPEMGDF
     I              MDSUTP                      SUTP
     I              MDCLAS                      CLAS

     ILENPVAD0
     I              LNLNST                      SUTP
     I              LNLNCL                      CLAS
     ILENPVLD0
     I              LELNST                      SUTP
     I              LELNCL                      CLAS

     ILEHNPVAD0
     I              LNLNST                      SUTP
     I              LNLNCL                      CLAS
     ILEHNPVLD0
     I              LELNST                      SUTP
     I              LELNCL                      CLAS

     C                   EXSR      P_CLOANCL
     C                   EXSR      P_MCLONCL

     C                   EXSR      P_FCLTYFM
     C                   EXSR      P_LEFCLTQD

     C                   EXSR      P_LEAGFMPD
     C                   EXSR      P_LEAGFTQD

     C                   EXSR      P_LEFEED

     C                   EXSR      P_LEPARTPD

     C                   EXSR      P_LOAMSDK

     C                   EXSR      P_LEPELND
     C                   EXSR      P_LEPEMGD

     C                   EXSR      P_LENPVAPD
     C                   EXSR      P_LENPVLPD
     C                   EXSR      P_LEHNPAPD
     C                   EXSR      P_LEHNPLPD

     C                   EXSR      P_HISTSHM
     C                   EXSR      P_HISTSHP
     C                   EXSR      P_MHISTHM
     C                   EXSR      P_MHISTHP

     C                   ADD       1             Count             3 0

     CLR                 EXSR      FINISH
      /SPACE 5
      ********************************************************************
     C     P_CLOANCL     BEGSR
     C                   READ      CLOANCL                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    CLOANCLO
     C                   READ      CLOANCL                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_MCLONCL     BEGSR
     C                   READ      MCLONCL                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    MCLONCLO
     C                   READ      MCLONCL                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_FCLTYFM     BEGSR
     C                   READ      FCLTYFM                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    FCLTYFMO
     C                   READ      FCLTYFM                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LEFCLTQD    BEGSR
     C                   READ      LEFCLTQD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LEFCLTQDO
     C                   READ      LEFCLTQD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LEAGFMPD    BEGSR
     C                   READ      LEAGFMPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LEAGFMPDO
     C                   READ      LEAGFMPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LEAGFTQD    BEGSR
     C                   READ      LEAGFTQD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LEAGFTQDO
     C                   READ      LEAGFTQD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LEFEED      BEGSR
     C                   READ      LEFEED                                 99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LEFEEDO
     C                   READ      LEFEED                                 99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LEPARTPD    BEGSR
     C                   READ      LEPARTPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LEPARTPDO
     C                   READ      LEPARTPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LOAMSDK     BEGSR
     C                   READ      LOAMSDK                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LOAMSDKO
     C                   READ      LOAMSDK                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LEPELND     BEGSR
     C                   READ      LEPELND                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LEPELNDO
     C                   READ      LEPELND                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LEPEMGD     BEGSR
     C                   READ      LEPEMGD                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LEPEMGDO
     C                   READ      LEPEMGD                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LENPVAPD    BEGSR
     C                   READ      LENPVAPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LENPVAPDO
     C                   READ      LENPVAPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LENPVLPD    BEGSR
     C                   READ      LENPVLPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LENPVLPDO
     C                   READ      LENPVLPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LEHNPAPD    BEGSR
     C                   READ      LEHNPAPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LEHNPAPDO
     C                   READ      LEHNPAPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_LEHNPLPD    BEGSR
     C                   READ      LEHNPLPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    LEHNPLPDO
     C                   READ      LEHNPLPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_HISTSHM     BEGSR
     C                   READ      HISTSHM                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    HISTSHMO
     C                   READ      HISTSHM                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_HISTSHP     BEGSR
     C                   READ      HISTSHP                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    HISTSHPO
     C                   READ      HISTSHP                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_MHISTHM     BEGSR
     C                   READ      MHISTHM                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    MHISTHMO
     C                   READ      MHISTHM                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_MHISTHP     BEGSR
     C                   READ      MHISTHP                                99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      Set_CLASS
     C                   EXCEPT    MHISTHPO
     C                   READ      MHISTHP                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     SET_Class     BEGSR

     C     SUTP          IFNE      *BLANK
     C                   EVAL      CLAS = LECLAS
     C                   ENDIF

     C     DFST          IFNE      *BLANK
     C                   EVAL      DFCL = LECLAS
     C                   ENDIF

     C     SLST          IFNE      *BLANK
     C                   EVAL      SLCL = LECLAS
     C                   ENDIF

     C     DRST          IFNE      *BLANK
     C                   EVAL      DRCL = LECLAS
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FINISH        BEGSR
     C                   OPEN      QSYSPRT

      * Report error or completion

     C     Count         IFNE      1
     C                   EXCEPT    ERR
     C                   SETON                                        U8
     C                   ELSE
     C                   EXCEPT    FIN
     C                   ENDIF

     C                   CLOSE     QSYSPRT
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
     C                   ENDSR
      ********************************************************************
     OQSYSPRT   E            ERR         1
     O                                           26 'PROGRAM ERROR - SDTCLDPD'
     O          E            FIN         1
     O                                           26 'PROGRAM COMPLETED NORMALLY'
     OCLOANCLF  E            CLOANCLO
     O                       CLAS
     O                       DFCL
     O                       SLCL
     OMCLONCLF  E            MCLONCLO
     O                       CLAS
     O                       DFCL
     O                       SLCL
     OFCLTYFMF  E            FCLTYFMO
     O                       DFCL
     OLEFCLTD0  E            LEFCLTQDO
     O                       SLCL
     O                       DRCL
     OLEAGFMF   E            LEAGFMPDO
     O                       DFCL
     OLEAGFTD0  E            LEAGFTQDO
     O                       SLCL
     O                       DRCL
     OLEFEEDF   E            LEFEEDO
     O                       CLAS
     OLEPARTD0  E            LEPARTPDO
     O                       DRCL
     OLOAMSDKF  E            LOAMSDKO
     O                       CLAS
     O                       DFCL
     O                       SLCL
     OLEPELNDF  E            LEPELNDO
     O                       CLAS
     OLEPEMGDF  E            LEPEMGDO
     O                       CLAS
     OLENPVAD0  E            LENPVAPDO
     O                       CLAS
     OLENPVLD0  E            LENPVLPDO
     O                       CLAS
     OLEHNPVAD0 E            LEHNPAPDO
     O                       CLAS
     OLEHNPVLD0 E            LEHNPLPDO
     O                       CLAS
     OHISTSHMF  E            HISTSHMO
     O                       CLAS
     OHISTSHPF  E            HISTSHPO
     O                       CLAS
     OMHISTHMF  E            MHISTHMO
     O                       CLAS
     OMHISTHPF  E            MHISTHPO
     O                       CLAS
      ********************************************************************
