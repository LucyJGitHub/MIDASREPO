     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Format Field from BIC data')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0712 - Midas FT Format Field from BIC data                *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 EEE065 *Amend      Date 23Nov2004             *
      *                 EEE065             Date 22Sep2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *  EEE065 - Format CC for Canada                                *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Directory Information
      *
     FMEBICPL0  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Plus Information
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array containing Copyright statement
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTMA                 7     12
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
      *
     D P2PARM          DS           256
      * I : Preferential update
     D  P2InData               1    175
     D  P2Line1                1     35
     D  P2Line2               36     70
     D  P2Line3               71    105
     D  P2Line4              106    140
     D  P2Line5              141    175
      *
     D P3PARM          DS           256
      * O : Output format of line
     D  P3OutData              1    175
     D  P3Line1                1     35
     D  P3Line2               36     70
     D  P3Line3               71    105
     D  P3Line4              106    140
     D  P3Line5              141    175
 
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1Option          7
     C                   PARM                    P1Pccy            3
     C                   PARM                    P2Parm
     C                   PARM                    P3Parm
      *
      *  Set up primary reference
      *
     C                   Clear                   P0Rtn
     C                   Clear                   P3parm
     C                   MOVEL     P2Parm        W0PREF
     C                   Exsr      SrInit
 
     C                   If        P1Option = 'BICPLUS'
     C                   Exsr      SrBicPlus
     C                   Endif
      * Exit
     C                   Return
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrBicPlus: Format via Bic Plus                               *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrBicPlus     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrBicPlus'   @STK(Q)
 
     C                   If        %Subst(P2Line1:1:1) <> '/'
     C                   Eval      BiKey  = %subst(P2Line1:1:8)
     C                   Eval      BDBICC = %subst(P2Line1:1:8)
     C                   Eval      BDBICB = %subst(P2Line1:9:3)
     C                   Else
     C                   Eval      BiKey  = %subst(P2Line2:1:8)
     C                   Eval      BDBICC = %subst(P2Line2:1:8)
     C                   Eval      BDBICB = %subst(P2Line2:9:3)
     C                   Endif
 
      * Check if Bic Diectory
     C                   If        BDBICB = *blanks
     C                   Eval      BDBICB = 'XXX'
     C                   Endif
     C     KBicDl2       Chain     @BicDL2
      * If found exit
     C                   If        %Found
     C                   If        %Subst(P2Line1:1:1) <> '/'
     C                   Eval      P3Line1 = BDBICC + BDBICB
     C                   Else
     C                   Eval      P3Line2 = BDBICC + BDBICB
     C                   Endif
     C                   Goto      ExBicPlus
     C                   Endif
 
      * Check if Bic Plus Key
     C     KBicPl0       Chain     @BicPPd
      * If found format depending on account line
     C                   If        %Found
     C                   Select
                                                                                              EEE065
     C                   When      %Subst(P2Line1:1:1) <> '/' and                             EEE065
     C                             %Subst(BiKey:2:2) <> 'CA'                                  EEE065
     C                             And P1Pccy = 'CAD' and BiNati <> *blanks                   EEE065
     C                   Eval      P3Line1 = '/' + 'CC' + BiNati                              EEE065
     C                   Eval      P3Line2 = %subst(biinst:1:35)                              EEE065
     C                   Eval      P3Line3 = %subst(biAddr:1:35)                              EEE065
     C                   Eval      P3Line4 = %subst(biLocn:1:35)                              EEE065
     C                   Eval      P3Line5 = %subst(biCnty:1:35)                              EEE065
     C                   When      %Subst(P2Line1:1:1) <> '/'
     C                             And P1Pccy = 'USD' and BiChip <> *blanks
     C                   Eval      P3Line1 = '/' + 'CH' + BiChip
     C                   Eval      P3Line2 = %subst(biinst:1:35)
     C****               Eval      SACB2   = %subst(bibnch:1:35)
     C                   Eval      P3Line3 = %subst(biAddr:1:35)
     C                   Eval      P3Line4 = %subst(biLocn:1:35)
     C                   Eval      P3Line5 = %subst(biCnty:1:35)
     C                   When      %Subst(P2Line1:1:1) <> '/' and                             EEE065
     C                             %Subst(BiKey:2:2) <> 'CA'                                  EEE065
     C                             And P1Pccy = 'USD' and BiNati <> *blanks                   EEE065
     C                   Eval      P3Line1 = '/' + 'CC' + BiNati                              EEE065
     C                   Eval      P3Line2 = %subst(biinst:1:35)                              EEE065
     C                   Eval      P3Line3 = %subst(biAddr:1:35)                              EEE065
     C                   Eval      P3Line4 = %subst(biLocn:1:35)                              EEE065
     C                   Eval      P3Line5 = %subst(biCnty:1:35)                              EEE065
     C                   When      %Subst(P2Line1:1:1) <> '/'
     C                   Eval      P3Line1 = %subst(biinst:1:35)
     C****               Eval      SACB2   = %subst(bibnch:1:35)
     C                   Eval      P3Line2 = %subst(biAddr:1:35)
     C                   Eval      P3Line3 = %subst(biLocn:1:35)
     C                   Eval      P3Line4 = %subst(biCnty:1:35)
     C                   Other
     C                   Eval      P3Line1 = P2Line1
     C                   Eval      P3Line2 = %subst(biinst:1:35)
     C****               Eval      SACB2   = %subst(bibnch:1:35)
     C                   Eval      P3Line3 = %subst(biAddr:1:35)
     C                   Eval      P3Line4 = %subst(biLocn:1:35)
     C                   Eval      P3Line5 = %subst(biCnty:1:35)
     C                   Endsl
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExBicPlus     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrInit        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      * Define keys
      * Bic Plus
     C     KBicPL0       Klist
     C                   Kfld                    Bikey
      * Bic Directory
     C     KBicDL2       Klist
     C                   Kfld                    BDBICC
     C                   Kfld                    BDBICB
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *================================================================
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
