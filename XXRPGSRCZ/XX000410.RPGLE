     H DEBUG
     H*COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')                         JMI112
     H COPYRIGHT('(c) Finastra International System 2018')                                    JMI112
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Proj Nostro Mvnts Discrepancy extract')       *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL000032*-*Midas*Projected*Nostro*Mvnts*Discrepancy*Extract***                       JMI112
      *  XX000410 - Midas Projected Nostro Mvnts Discrepancy Extract  *                       JMI112
      *                                                               *
      *  Function:  This module will compare records on shadow        *
      *             postings file RSACMTPD.                           *
      *             Discrepancies should result in the data being     *
      *             output to MQ Series Queue NUPDUPDCOB              *
      *                                                               *
      *  Component of: GLC0802C                                       *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************                       JMI112
      *  (c) Finastra International Limited 2018                      *                       JMI112
      *                                                               *
      *  Last Amend No. JMI112             Date 24May18               *
      *  Prev Amend No. CGL086  *CREATE    Date 31Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI112 - Midas-Opics Data Transfer Amendments. Upgrade to    *
      *           FBM 2.1                                             *
      *  CGL086 - Midas-Opics Data Transfer Amendments                *
      *                                                               *
      *****************************************************************
      /EJECT
     FRSACMTPD  IF   E           K DISK    INFSR(*PSSR)
     F*GLACMTPD**IF   E           K DISK    INFSR(*PSSR)                                      JMI112
     FXXACMTPD  IF   E           K DISK    INFSR(*PSSR)                                       JMI112
     F                                     PREFIX(@)
     F*RSACMTL9**IF   E           K DISK    INFSR(*PSSR)                                      JMI112
     FXXACMTL3  IF   E           K DISK    INFSR(*PSSR)                                       JMI112
     F                                     RENAME(RSACMTPO:RSACMTP)
     F*GLACMTL0**IF   E           K DISK    INFSR(*PSSR)                                      JMI112
     F***********                          RENAME(GLACMTD0:GLACMTD)                           JMI112
     FXXACMTL0  IF   E           K DISK    INFSR(*PSSR)                                       JMI112
     F                                     RENAME(XXACMTD0:XXACMTD)                           JMI112
     F                                     PREFIX(@)
     F*RSACMTL10*IF   E           K DISK    INFSR(*PSSR)                                      JMI112
     FXXACMTL2  IF   E           K DISK    INFSR(*PSSR)                                       JMI112
     F                                     RENAME(RSACMTPO:RSACMTL)
     F*GLACMTL1**IF   E           K DISK    INFSR(*PSSR)                                      JMI112
     F***********                          RENAME(GLACMTD0:GLACMTY)                           JMI112
     FXXACMTL1  IF   E           K DISK    INFSR(*PSSR)                                       JMI112
     F                                     RENAME(XXACMTD0:XXACMTY)                           JMI112
     F                                     PREFIX(@)
      /SPACE 3
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
      *
      *****************************************************************
      ** Retail Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)

      ** DS for Access Object Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Breakdown of Data to be output to MQ Series Queue
     D                 DS
     D  DataQueueVal           1    103
     D*ICUSN*****              1      6S 0                                                    JMI112
     D ICUSN                   1      6                                                       JMI112
     D ICCYD                   7      9
     D IACDE                  10     19S 0
     D IASNC                  20     21S 0
     D IBRCA                  22     24
     D IPTDT                  25     29S 0
     D IVUDT                  30     34S 0
     D ITRYP                  35     36
     D INRTD                  37     66
     D ITNMR                  67     72
     D IMVAM                  73     87S 0
     D IDORC                  88     88S 0
     D IFUND                  89    103
      *
     D DataQueueName   S             10A   INZ('NUPDUPDCOB')
     D DataQueueLib    S             10A   INZ('*LIBL     ')

      /SPACE 3
      *****************************************************************
      * Main Subroutine
      *
     C                   READ      RSACMTPD                               80
      *
      * Do until end of file
     C     *IN80         DOWNE     *ON
      *
     C                   movel     CUSN          CUSN_A            6
     C                   movel     ACDE          ACDE_A           10
     C                   movel     ASNC          ASNC_A            2
      *
      * Ascertain if the account is a Nostro, if not then read next record
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY    '    @Optn
     C                   Parm      *BLANKS       W@Retl           10
     C                   Parm      CUSN_A        WCusN             6
     C                   Parm      CCYD          W@Cur             3
     C                   Parm      ACDE_A        W@Acctcde        10
     C                   Parm      ASNC_A        W@AcctSeq         2
     C                   Parm      BRCA          W@Brch            3
     C     SDACCT        Parm      SDACCT        DSSDY
      *
     C     ATYP          IFNE      'N'
     C                   GOTO      TAG1
     C                   ENDIF
      *
     C                   MOVE      CUSN          KCUSN
     C                   MOVE      CCYD          KCCYD
     C                   MOVE      ACDE          KACDE
     C                   MOVE      ASNC          KASNC
     C                   MOVE      BRCA          KBRCA
     C                   MOVE      TRYP          KTRYP
     C                   MOVE      DORC          KDORC
     C                   MOVE      VUDT          KVUDT

     C     FUND          IFEQ      *BLANKS
     C                   MOVE      TNMR          KTNMR
      * Access copy of RSACMTPD to see if record exists.
     C*****KLIST1*       CHAIN     GLACMTL0                           81                      JMI112
     C     KLIST1        CHAIN     XXACMTL0                           81                      JMI112
      *
     C                   ELSE
     C                   MOVE      FUND          KFUND
      * Access copy of RSACMTPD to see if record exists.
     C*****KLIST2*       CHAIN     GLACMTL1                           81                      JMI112
     C     KLIST2        CHAIN     XXACMTL1                           81                      JMI112
     C                   ENDIF
      *
      * If record not found then output details from RSACMTPD to
      * MQ Series Queue
     C     *IN81         IFEQ      *ON
     C                   MOVE      CUSN          ICUSN
     C                   MOVE      CCYD          ICCYD
     C                   MOVE      ACDE          IACDE
     C                   MOVE      ASNC          IASNC
     C                   MOVE      BRCA          IBRCA
     C                   MOVE      PTDT          IPTDT
     C                   MOVE      VUDT          IVUDT
     C                   MOVE      TRYP          ITRYP
     C                   MOVE      NRTD          INRTD
     C                   MOVE      TNMR          ITNMR
     C                   CALL      'ZSEDIT'
     C                   PARM      MVAM          ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
     C                   MOVEL     ZOUT21        IMVAM20          20
     C                   MOVE      IMVAM20       IMVAM
     C                   MOVE      DORC          IDORC
     C                   MOVE      FUND          IFUND

     C                   Call      'QSNDDTAQ'                           90
     C                   Parm                    DataQueueName
     C                   Parm                    DataQueueLib
     C                   Parm                    DataQueueLen      5 0
     C                   Parm                    DataQueueVal
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If record found but amounts differ then output details
      **from*RSACMTPD.*Then*output*details*from*GLACMTPD*reversing*Dr/Cr*ind.                 JMI112
      * from RSACMTPD. Then output details from XXACMTPD reversing Dr/Cr ind.                 JMI112
      *
     C     *IN81         IFEQ      *OFF
     C     MVAM          ANDNE     @MVAM
     C                   MOVE      CUSN          ICUSN
     C                   MOVE      CCYD          ICCYD
     C                   MOVE      ACDE          IACDE
     C                   MOVE      ASNC          IASNC
     C                   MOVE      BRCA          IBRCA
     C                   MOVE      PTDT          IPTDT
     C                   MOVE      VUDT          IVUDT
     C                   MOVE      TRYP          ITRYP
     C                   MOVE      NRTD          INRTD
     C                   MOVE      TNMR          ITNMR
     C                   CALL      'ZSEDIT'
     C                   PARM      MVAM          ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
     C                   MOVE      ZOUT21        IMVAM
     C                   MOVE      DORC          IDORC
     C                   MOVE      FUND          IFUND
      *
     C                   Call      'QSNDDTAQ'                           90
     C                   Parm                    DataQueueName
     C                   Parm                    DataQueueLib
     C                   Parm                    DataQueueLen      5 0
     C                   Parm                    DataQueueVal
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      @CUSN         ICUSN
     C                   MOVE      @CCYD         ICCYD
     C                   MOVE      @ACDE         IACDE
     C                   MOVE      @ASNC         IASNC
     C                   MOVE      @BRCA         IBRCA
     C                   MOVE      @PTDT         IPTDT
     C                   MOVE      @VUDT         IVUDT
     C                   MOVE      @TRYP         ITRYP
     C                   MOVE      @NRTD         INRTD
     C                   MOVE      @TNMR         ITNMR
     C                   CALL      'ZSEDIT'
     C                   PARM      @MVAM         ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
     C                   MOVE      ZOUT21        IMVAM
     C     @DORC         IFEQ      1
     C                   MOVE      '0'           IDORC
     C                   ELSE
     C                   MOVE      '1'           IDORC
     C                   ENDIF
     C                   MOVE      @FUND         IFUND
      *
     C                   Call      'QSNDDTAQ'                           90
     C                   Parm                    DataQueueName
     C                   Parm                    DataQueueLib
     C                   Parm                    DataQueueLen      5 0
     C                   Parm                    DataQueueVal
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     TAG1          TAG
      *
      * Read next record on RSACMTPD
     C                   READ      RSACMTPD                               80
     C                   ENDDO

     C***********        READ      GLACMTPD                               80                  JMI112
     C                   READ      XXACMTPD                               80                  JMI112
     C
      * Do until end of file
     C     *IN80         DOWNE     *ON
      *
     C                   movel     @CUSN         @CUSN_A           6
     C                   movel     @ACDE         @ACDE_A          10
     C                   movel     @ASNC         @ASNC_A           2
      *
      * Ascertain if the account is a Nostro, if not then read next record
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY    '    @Optn
     C                   Parm      *BLANKS       W@Retl           10
     C                   Parm      @CUSN_A       WCusN             6
     C                   Parm      @CCYD         W@Cur             3
     C                   Parm      @ACDE_A       W@Acctcde        10
     C                   Parm      @ASNC_A       W@AcctSeq         2
     C                   Parm      @BRCA         W@Brch            3
     C     SDACCT        Parm      SDACCT        DSSDY
      *
     C     ATYP          IFNE      'N'
     C                   GOTO      TAG2
     C                   ENDIF
      *
     C                   MOVE      @CUSN         KCUSN
     C                   MOVE      @CCYD         KCCYD
     C                   MOVE      @ACDE         KACDE
     C                   MOVE      @ASNC         KASNC
     C                   MOVE      @BRCA         KBRCA
     C                   MOVE      @TRYP         KTRYP
     C                   MOVE      @DORC         KDORC
     C                   MOVE      @VUDT         KVUDT
      *
     C     @FUND         IFEQ      *BLANKS
     C                   MOVE      @TNMR         KTNMR
      * Access copy of RSACMTPD to see if record exists.
     C*****KLIST1        CHAIN     RSACMTL9                           81                      JMI112
     C     KLIST1        CHAIN     XXACMTL3                           81                      JMI112
      *
     C                   ELSE
     C                   MOVE      @FUND         KFUND
      * Access copy of RSACMTPD to see if record exists.
     C*****KLIST2        CHAIN     RSACMTL10                          81                      JMI112
     C     KLIST2        CHAIN     XXACMTL2                           81                      JMI112
     C                   ENDIF
      *
      **If*record*not*found*then*output*details*from*GLACMTPD*to                              JMI112
      * If record not found then output details from XXACMTPD to                              JMI112
      * MQ Series Queue
     C     *IN81         IFEQ      *ON
     C                   MOVE      @CUSN         ICUSN
     C                   MOVE      @CCYD         ICCYD
     C                   MOVE      @ACDE         IACDE
     C                   MOVE      @ASNC         IASNC
     C                   MOVE      @BRCA         IBRCA
     C                   MOVE      @PTDT         IPTDT
     C                   MOVE      @VUDT         IVUDT
     C                   MOVE      @TRYP         ITRYP
     C                   MOVE      @NRTD         INRTD
     C                   MOVE      @TNMR         ITNMR
     C                   CALL      'ZSEDIT'
     C                   PARM      @MVAM         ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
     C                   MOVE      ZOUT21        IMVAM
     C     @DORC         IFEQ      1
     C                   MOVE      '0'           IDORC
     C                   ELSE
     C                   MOVE      '1'           IDORC
     C                   ENDIF
     C                   MOVE      @FUND         IFUND
      *
     C                   Call      'QSNDDTAQ'                           90
     C                   Parm                    DataQueueName
     C                   Parm                    DataQueueLib
     C                   Parm                    DataQueueLen      5 0
     C                   Parm                    DataQueueVal
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     TAG2          TAG
     C***********        READ      GLACMTPD                               80                  JMI112
     C                   READ      XXACMTPD                               80                  JMI112
     C                   ENDDO

      * End Program
     C                   SETON                                            LR
     C                   RETURN
      /EJECT
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     KLIST1        KLIST
     C***********        KFLD                    KCUSN             6 0                        JMI112
     C                   KFLD                    KCUSN             6                          JMI112
     C                   KFLD                    KCCYD             3
     C                   KFLD                    KACDE            10 0
     C                   KFLD                    KASNC             2 0
     C                   KFLD                    KBRCA             3
     C                   KFLD                    KTRYP             2
     C                   KFLD                    KTNMR             6
     C                   KFLD                    KDORC             1 0
     C                   KFLD                    KVUDT             5 0
      *
     C     KLIST2        KLIST
     C***********        KFLD                    KCUSN             6 0                        JMI112
     C                   KFLD                    KCUSN             6                          JMI112
     C                   KFLD                    KCCYD             3
     C                   KFLD                    KACDE            10 0
     C                   KFLD                    KASNC             2 0
     C                   KFLD                    KBRCA             3
     C                   KFLD                    KTRYP             2
     C                   KFLD                    KFUND            21
     C                   KFLD                    KDORC             1 0
     C                   KFLD                    KVUDT             5 0
      *
      * Clear Data Queue
     C                   Call      'QCLRDTAQ'                           90
     C                   Parm                    DataQueueName
     C                   Parm                    DataQueueLib
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Eval      DataQueueLen = 103
      *
     C                   ENDSR
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
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2018                                                       JMI112
