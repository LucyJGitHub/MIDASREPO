     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Extract BIC Plus Quick Index')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0705 - Midas FT Extract BIC Plus Quick Index              *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 EEE065             Date 21Oct2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FMEBICPV0  IF   E           K DISK
     F                                     Rename(@bicpPd:@bicPv0)
     F                                     INFSR(SRFILE)
      * RTV : BIC Plus Directory Information
      *
     FFTBSCHV0  UF A E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Plus Index
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
     D BSchV0        E DS                  EXTNAME(FTBschV0)
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
 
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
      *
      *  Set up primary reference
      *
     C                   Clear                   P0Rtn
     C                   Movel     'Extract'     W0PREF
     C                   Exsr      SrInit
 
     C                   Exsr      SrBicPlus
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
 
      * Check if Bic Diectory
     C     KBicpV0       Klist
     C                   Kfld                    BIKEY
 
     C                   Clear                   BIKEY
 
     C     KBicpV0       Setll     @BicpV0
     C                   Read      @BicpV0                                90
      * If found continue and read whole file
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
 
     C     KBicpV0       Chain     @BSchV0
     C                   If        Not %Found
     C                   Clear                   @BSchV0
 
     C                   Eval      BSBIC   = BiBIC                              BIC Code
     C                   Eval      BSKEY   = BiKEY                              Key
     C                   Eval      BSSTYP  = BiSTYP                             Subtype
     C                   Eval      BSCHIP  = BiCHIP                             CHIPS
     C                   Eval      BSCNTC  = %Subst(Bikey:1:2)                  Country Code
     C                   Eval      BSNATI  = BiNATI                             National ID
     C                   Eval      BSACTD  = BiACTD                             Activation Date
     C                   Eval      BSDCTD  = BiDCTD                             Deactivation Date
 
     C                   Write     @BSchV0
     C                   Else
 
     C                   Eval      BSBIC   = BiBIC                              BIC Code
     C                   Eval      BSKEY   = BiKEY                              Key
     C                   Eval      BSSTYP  = BiSTYP                             Subtype
     C                   Eval      BSCHIP  = BiCHIP                             CHIPS
     C                   Eval      BSCNTC  = %Subst(Bikey:1:2)                  Country Code
     C                   Eval      BSNATI  = BiNATI                             National ID
     C                   Eval      BSACTD  = BiACTD                             Activation Date
     C                   Eval      BSDCTD  = BiDCTD                             Deactivation Date
 
     C                   Update    @BSchV0
     C                   Endif
 
     C                   Read      @BicpV0                                90
     C                   Enddo
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
