     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Upgrade CLOANCK file')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00081 - Upgrade CLOANCK with PC Reference                 *
      *                                                               *
      *  Function:  This program is run at installation time to set   *
      *             up new mandatory information on CLOANCK file.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 158177 *CREATE     Date 05May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S15817701.                         *
      *  158177  - All transactions input through Midas must have     *
      *            a full PC reference                                *
      *                                                               *
      *****************************************************************
     FCLOANCK   UF   E             DISK
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      *****************************************************************
     D*
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D**  External DS for Branch Details
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  DS for access programs, long data structure
      *
      *
      * DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
     D PUPDT           S              1A                                                      CLE148
     D PCNEXT          S              8A                                                      CLE148
     I*****************************************************************
     I*
     ICLOANCLF
      *
      ** Rename Fields
      *
     I              RECI                        WRECI
     I              LNRF                        WLNRF
     I              RCDT                        WRCDT
     I              MRIN                        WMRIN
     I              PTYP                        WPTYP
     I              CNUM                        WCNUM
     I              BRCA                        WBRCA
     I              LTYP                        WLTYP
     I              SUTP                        WSUTP
     I              VDAT                        WVDAT
     I              FCUS                        WFCUS
     I              FTYP                        WFTYP
     I              FSEQ                        WFSEQ
     I              CCY                         WCCY
     I              CPAM                        WCPAM
     I              INTC                        WINTC
     I              INTR                        WINTR
     I              BRTT                        WBRTT
     I              BRTE                        WBRTE
     I              RTSP                        WRTSP
     I              SPIN                        WSPIN
     I              CHIN                        WCHIN
     I              WTRT                        WWTRT
     I              WTIN                        WWTIN
     I              REPT                        WREPT
     I              NACD                        WNACD
     I              AUTO                        WAUTO
     I              FACO                        WFACO
     I              RDFC                        WRDFC
     I              PDIN                        WPDIN
     I              FCLB                        WFCLB
     I              BTIN                        WBTIN
     I              TOTI                        WTOTI
     I              IACD                        WIACD
     I              AITC                        WAITC
     I              AIAP                        WAIAP
     I              IPRD                        WIPRD
     I              ORED                        WORED
     I              LCD                         WLCD
     I              CHTP                        WCHTP
     I              TNLU                        WTNLU
     I              ADDI                        WADDI
     I              RSTM                        WRSTM
     I              RONS                        WRONS
     I              RIBN                        WRIBN
     I              RIBA                        WRIBA
     I              ROBN                        WROBN
     I              ROCN                        WROCN
     I              PSTM                        WPSTM
     I              PONS                        WPONS
     I              PIBN                        WPIBN
     I              PIBA                        WPIBA
     I              POBN                        WPOBN
     I              POCN                        WPOCN
     I              RCRN                        WRCRN
     I              RCRA                        WRCRA
     I              RVNO                        WRVNO
     I              AWBN                        WAWBN
     I              AWBA                        WAWBA
     I              BENN                        WBENN
     I              BENA                        WBENA
     I              DTP1                        WDTP1
     I              DTP2                        WDTP2
     I              DTP3                        WDTP3
     I              DTP4                        WDTP4
     I              DCHG                        WDCHG
     I              BTB1                        WBTB1
     I              BTB2                        WBTB2
     I              BTB3                        WBTB3
     I              BTB4                        WBTB4
     I              BTB5                        WBTB5
     I              BTB6                        WBTB6
     I              CVMR                        WCVMR
     I              FSRP                        WFSRP
     I              FSGN                        WFSGN
     I              FPRC                        WFPRC
     I              TCOF                        WTCOF
     I              ACDA                        WACDA
     I              COFD                        WCOFD
     I              MNSG                        WMNSG
     I              GASS                        WGASS
     I              GPRT                        WGPRT
      *
     C*****************************************************************
     C*
     C                   READ      CLOANCK                                50
     C*
     C     *IN50         DOWEQ     '0'
     C*
     C     LNRF          CHAIN     CLOAN                              26
     C*
     C** Access the SDBRCHPD for the details of Transaction Branch
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      WBRCA         PBRCA             3
     C     SDBRCH        PARM      *BLANK        DSSDY
     C*
     C                   MOVEL     A8MQSM        W#1ST3            3
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        RPCR
     C                   MOVE      '0001'        RPCR
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C*
     C*
     C                   UPDATE    CLOANCKF
     C                   READ      CLOANCK                                50
     C                   ENDDO
     C*
     C                   SETON                                        LR
     C*
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
