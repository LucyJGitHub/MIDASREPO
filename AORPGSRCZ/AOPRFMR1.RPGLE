     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Profit centre default retrieval')
      *****************************************************************
      *                                                               *
      *  Midas   Access Objects                                       *
      *                                                               *
      *  AOPRFMR1 - Profit Center Default Retrieval                   *
      *                                                               *
      *  Function:  This program Retrieves Default Profit Centre for  *
      *             Consumer Banking                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *  Indicator usage and return code information                  *
      *                                                               *
      *       11      BOOK PRIORITY IS NEXT LOWEST                    *
      *       12      TRANSACTION TYPE PRIORITY IS NEXT LOWEST        *
      *       13      SUB TYPE PRIORITY IS NEXT LOWEST                *
      *       14      BRANCH PRIORITY IS NEXT LOWEST                  *
      *       15      DEPARTMENT PRIORITY IS NEXT LOWEST              *
      *       16      USER PRIORITY IS NEXT LOWEST                    *
      *       17      ACCOUNT OFFICER PRIORITY IS NEXT LOWEST         *
      *       18      CUSTOMER NUMBER PRIORITY IS NEXT LOWEST         *
      *       30      PROFIT CENTRE NOT FOUND IF ON                   *
      *       55      CHAIN FAIL ON FILE SDPRFML1                     *
      *                                                               *
      *****************************************************************
      ***     RETURN CODES FROM THIS PROGRAMME                      ***
      *
      *       0       PROFIT CENTRE FOUND - NO ERROR
      *       1       DEFAULT NOT FOUND FOR THIS COMBINATION-BLANK
      *               PROFIT CENTRE IS RETUNED
      *       2       PROFIT CENTRE FOUND BUT IS INVALID
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      * Midas SD Profit centre dft matrix retrieval
     FSDPRFML1  IF   E           K DISK
      * Midas SD Customer marketing groups retrieval
     FSDCMRKL1  IF   E           K DISK
      * Midas SD Country codes retrieval
     FSDCTRYL1  IF   E           K DISK
      ****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *   External DS For General Ledger
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      *   External DS for profit centres
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      *
      *   External DS for Midas Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      *   External DS for Profit Centre Accounting ICD
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      *
      *   External DS for Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
      *
      *  External DS for Customer file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      *  Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             30     30
      *
      *  Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      * First DS for access programs,Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Second DS for access programs,Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D PRTNC           S              1A
     D PBOOK           S              2A
     D PTRTP           S              5A
     D PSUTP           S              2A
     D PBRAN           S              3A
     D PDEPT           S              3A
     D PUSER           S             10A
     D PACOF           S              2A
     D PCNUM           S              6A
     D PINDC           S              3A
     D PBNBK           S              1A
     D PCDOM           S              2A
     D PRDOM           S              2A
     D PCCTZ           S              2A
     D PRCTZ           S              2A
     D PCTYP           S              1A
     D PCMG1           S              4A
     D PCMG2           S              4A
     D PCMG3           S              4A
     D PCMG4           S              4A
     D PCMG5           S              4A
     D PPRFC           S              4A
 
     D LICD            S              3A
     D BNBI            S              1A
     D CLOC            S              2A
     D RLOC            S              2A
     D CNCZ            S              2A
     D RNCZ            S              2A
     D CSTY            S              1A
     D GPC1            S              4A
     D GPC2            S              4A
     D GPC3            S              4A
     D GPC4            S              4A
     D GPC5            S              4A
 
     D STARS           S             10A
     D COUNT           S              2  0
     D @SARD           S              6A
     D CAC004          S              1A
     D CSD009          S              1A
     D WCounter        S              2  0
     D WAvoidPr        S              2  0
     D @RTCD           S              7A
     D @OPTN           S              7A
     D WKPMBK          S              1  0
     D WKPMTT          S              1  0
     D WKPMST          S              1  0
     D WKPMBH          S              1  0
     D WKPMDT          S              1  0
     D WKPMUR          S              1  0
     D WKPMAO          S              1  0
     D WKPMCU          S              1  0
     D WKLICD          S              1  0
     D WKBNBI          S              1  0
     D WKCLOC          S              1  0
     D WKRLOC          S              1  0
     D WKCNCZ          S              1  0
     D WKRNCZ          S              1  0
     D WKCSTY          S              1  0
     D WKGPC1          S              1  0
     D WKGPC2          S              1  0
     D WKGPC3          S              1  0
     D WKGPC4          S              1  0
     D WKGPC5          S              1  0
     D WBOOK           S              2A
     D WTRTP           S              5A
     D WSUTP           S              2A
     D WBRAN           S              3A
     D WDEPT           S              3A
     D WUSER           S             10A
     D WACOF           S              2A
     D WCNUM           S              6A
     D WLICD           S              3A
     D WBNBI           S              1A
     D WCLOC           S              2A
     D WRLOC           S              2A
     D WCNCZ           S              2A
     D WRNCZ           S              2A
     D WCSTY           S              1A
     D WGPC1           S              4A
     D WGPC2           S              4A
     D WGPC3           S              4A
     D WGPC4           S              4A
     D WGPC5           S              4A
     D @KEY            S              4A
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
     C                   MOVEA     CPY@          BIS@             80
      *
      ** Input Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTNC
     C                   PARM                    PBOOK
     C                   PARM                    PTRTP
     C                   PARM                    PSUTP
     C                   PARM                    PBRAN
     C                   PARM                    PDEPT
     C                   PARM                    PUSER
     C                   PARM                    PACOF
     C                   PARM                    PCNUM
     C                   PARM                    PINDC
     C                   PARM                    PBNBK
     C                   PARM                    PCDOM
     C                   PARM                    PRDOM
     C                   PARM                    PCCTZ
     C                   PARM                    PRCTZ
     C                   PARM                    PCTYP
     C                   PARM                    PCMG1
     C                   PARM                    PCMG2
     C                   PARM                    PCMG3
     C                   PARM                    PCMG4
     C                   PARM                    PCMG5
     C                   PARM                    PPRFC
      *
      ** Key Fields
      *
     C     FLKEY         KLIST
     C                   KFLD                    PBOOK
     C                   KFLD                    PTRTP
     C                   KFLD                    PSUTP
     C                   KFLD                    PBRAN
     C                   KFLD                    PDEPT
     C                   KFLD                    PUSER
     C                   KFLD                    PACOF
     C                   KFLD                    PCNUM
      *
      ** Key list used when CSD009 enhancement is installed.
      ** Additional key fields, for default matrix file
      *
     C     KFLKEY        KLIST
     C                   KFLD                    PBOOK
     C                   KFLD                    PTRTP
     C                   KFLD                    PSUTP
     C                   KFLD                    PBRAN
     C                   KFLD                    PDEPT
     C                   KFLD                    PUSER
     C                   KFLD                    PACOF
     C                   KFLD                    PCNUM
     C                   KFLD                    LICD
     C                   KFLD                    BNBI
     C                   KFLD                    CLOC
     C                   KFLD                    RLOC
     C                   KFLD                    CNCZ
     C                   KFLD                    RNCZ
     C                   KFLD                    CSTY
     C                   KFLD                    GPC1
     C                   KFLD                    GPC2
     C                   KFLD                    GPC3
     C                   KFLD                    GPC4
     C                   KFLD                    GPC5
      *
     C                   MOVEL     '********'    STARS
     C                   MOVE      '**'          STARS
     C                   Z-ADD     0             COUNT
     C                   MOVE      *BLANKS       PRTNC
      *
     C     PBOOK         IFEQ      *BLANKS
     C                   MOVE      STARS         PBOOK
     C                   ENDIF
      *
     C     PTRTP         IFEQ      *BLANKS
     C                   MOVE      STARS         PTRTP
     C                   ENDIF
      *
     C     PSUTP         IFEQ      *BLANKS
     C                   MOVE      STARS         PSUTP
     C                   ENDIF
      *
     C     PBRAN         IFEQ      *BLANKS
     C                   MOVE      STARS         PBRAN
     C                   ENDIF
      *
     C     PDEPT         IFEQ      *BLANKS
     C                   MOVE      STARS         PDEPT
     C                   ENDIF
      *
     C     PUSER         IFEQ      *BLANKS
     C                   MOVE      STARS         PUSER
     C                   ENDIF
      *
     C     PACOF         IFEQ      *BLANKS
     C                   MOVE      STARS         PACOF
     C                   ENDIF
      *
     C     PCNUM         IFEQ      *BLANKS
     C                   MOVE      STARS         PCNUM
     C                   END
      *
      ** Check if Analytical Accounting is installed
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** If Analytical Accounting installed
      ** Access AOSARDR0 to check if CAC004 (Default Unallocated Prf Ctr)
      ** is switched on
      *
     C     BGN0ST        IFEQ      'Y'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAC004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAC004
     C                   ELSE
     C                   MOVE      'N'           CAC004
     C                   ENDIF
      *
      ** and obtain the 'Unallocated Profit Centre' from PF/SDPCACPD
      *
     C                   CALL      'AOPCACR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
     C                   ENDIF
      *
      ** Check if CSD009 - PCA Default Matrix Enhancement is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   MOVE      'Y'           CSD009
     C                   ELSE
     C                   MOVE      'N'           CSD009
     C                   ENDIF
     C/COPY WNCPYSRC,AOPRFMR1C1
      *
      ** Setup new parameteres
      *
     C                   EVAL      LICD = PINDC
     C                   EVAL      BNBI = PBNBK
     C                   EVAL      CLOC = PCDOM
     C                   EVAL      RLOC = PRDOM
     C                   EVAL      CNCZ = PCCTZ
     C                   EVAL      RNCZ = PRCTZ
     C                   EVAL      CSTY = PCTYP
     C                   EVAL      GPC1 = PCMG1
     C                   EVAL      GPC2 = PCMG2
     C                   EVAL      GPC3 = PCMG3
     C                   EVAL      GPC4 = PCMG4
     C                   EVAL      GPC5 = PCMG5
      *
      ** For each new parameter field, set to stars if blanks
      *
     C                   IF        LICD = *BLANKS
     C                   MOVE      STARS         LICD
     C                   ENDIF
      *
     C                   IF        BNBI = *BLANKS
     C                   MOVE      STARS         BNBI
     C                   ENDIF
      *
     C                   IF        CLOC = *BLANKS
     C                   MOVE      STARS         CLOC
     C                   ENDIF
      *
     C                   IF        RLOC = *BLANKS
     C                   MOVE      STARS         RLOC
     C                   ENDIF
      *
     C                   IF        CNCZ = *BLANKS
     C                   MOVE      STARS         CNCZ
     C                   ENDIF
      *
     C                   IF        RNCZ = *BLANKS
     C                   MOVE      STARS         RNCZ
     C                   ENDIF
      *
     C                   IF        CSTY = *BLANKS
     C                   MOVE      STARS         CSTY
     C                   ENDIF
      *
     C                   IF        GPC1 = *BLANKS
     C                   MOVE      STARS         GPC1
     C                   ENDIF
      *
     C                   IF        GPC2 = *BLANKS
     C                   MOVE      STARS         GPC2
     C                   ENDIF
      *
     C                   IF        GPC3 = *BLANKS
     C                   MOVE      STARS         GPC3
     C                   ENDIF
      *
     C                   IF        GPC4 = *BLANKS
     C                   MOVE      STARS         GPC4
     C                   ENDIF
      *
     C                   IF        GPC5 = *BLANKS
     C                   MOVE      STARS         GPC5
     C                   ENDIF
      *
      ** Set Counter and Avoid Priority field to zero
      *
     C                   Z-ADD     0             WCounter
     C                   Z-ADD     0             WAvoidPr
      *
      ** Obtain Profit Centre Default Matrix priorities from SDGELRPD
      ** by accessing GENERAL LEDGER
      *
     C                   CALLB     'AOGELRR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Remember priority number of each default field and save
      ** it to a numeric field
      *
     C                   MOVE      BKPMBK        WKPMBK
     C                   MOVE      BKPMTT        WKPMTT
     C                   MOVE      BKPMST        WKPMST
     C                   MOVE      BKPMBH        WKPMBH
     C                   MOVE      BKPMDT        WKPMDT
     C                   MOVE      BKPMUR        WKPMUR
     C                   MOVE      BKPMAO        WKPMAO
     C                   MOVE      BKPMCU        WKPMCU
     C                   MOVE      BKLICD        WKLICD
     C                   MOVE      BKBNBI        WKBNBI
     C                   MOVE      BKCLOC        WKCLOC
     C                   MOVE      BKRLOC        WKRLOC
     C                   MOVE      BKCNCZ        WKCNCZ
     C                   MOVE      BKRNCZ        WKRNCZ
     C                   MOVE      BKCSTY        WKCSTY
     C                   MOVE      BKGPC1        WKGPC1
     C                   MOVE      BKGPC2        WKGPC2
     C                   MOVE      BKGPC3        WKGPC3
     C                   MOVE      BKGPC4        WKGPC4
     C                   MOVE      BKGPC5        WKGPC5
      *
      ** If one of the priorities is zero,set the relevant key to
      ** asterisks, else add one to number of non-zero priorities
      *
     C     BKPMBK        IFEQ      '0'
     C                   MOVE      STARS         PBOOK
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKPMTT        IFEQ      '0'
     C                   MOVE      STARS         PTRTP
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKPMST        IFEQ      '0'
     C                   MOVE      STARS         PSUTP
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKPMBH        IFEQ      '0'
     C                   MOVE      STARS         PBRAN
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKPMDT        IFEQ      '0'
     C                   MOVE      STARS         PDEPT
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKPMUR        IFEQ      '0'
     C                   MOVE      STARS         PUSER
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKPMAO        IFEQ      '0'
     C                   MOVE      STARS         PACOF
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
      *
     C     BKPMCU        IFEQ      '0'
     C                   MOVE      STARS         PCNUM
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C                   IF        CSD009 = 'Y'
      *
     C     BKLICD        IFEQ      '0'
     C                   MOVE      STARS         LICD
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKBNBI        IFEQ      '0'
     C                   MOVE      STARS         BNBI
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKCLOC        IFEQ      '0'
     C                   MOVE      STARS         CLOC
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKRLOC        IFEQ      '0'
     C                   MOVE      STARS         RLOC
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKCNCZ        IFEQ      '0'
     C                   MOVE      STARS         CNCZ
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKRNCZ        IFEQ      '0'
     C                   MOVE      STARS         RNCZ
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKCSTY        IFEQ      '0'
     C                   MOVE      STARS         CSTY
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKGPC1        IFEQ      '0'
     C                   MOVE      STARS         GPC1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKGPC2        IFEQ      '0'
     C                   MOVE      STARS         GPC2
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKGPC3        IFEQ      '0'
     C                   MOVE      STARS         GPC3
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKGPC4        IFEQ      '0'
     C                   MOVE      STARS         GPC4
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C     BKGPC5        IFEQ      '0'
     C                   MOVE      STARS         GPC5
     C                   ELSE
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** For each parameter, save original value to work variable
      ** for parameters
      *
     C                   MOVEL     PBOOK         WBOOK
     C                   MOVEL     PTRTP         WTRTP
     C                   MOVEL     PSUTP         WSUTP
     C                   MOVEL     PBRAN         WBRAN
     C                   MOVEL     PDEPT         WDEPT
     C                   MOVEL     PUSER         WUSER
     C                   MOVEL     PACOF         WACOF
     C                   MOVEL     PCNUM         WCNUM
     C                   MOVEL     LICD          WLICD
     C                   MOVEL     BNBI          WBNBI
     C                   MOVEL     CLOC          WCLOC
     C                   MOVEL     RLOC          WRLOC
     C                   MOVEL     CNCZ          WCNCZ
     C                   MOVEL     RNCZ          WRNCZ
     C                   MOVEL     CSTY          WCSTY
     C                   MOVEL     GPC1          WGPC1
     C                   MOVEL     GPC2          WGPC2
     C                   MOVEL     GPC3          WGPC3
     C                   MOVEL     GPC4          WGPC4
     C                   MOVEL     GPC5          WGPC5
      *
      ** Turn on indicator for record not found, and set work
      ** variable for counter to total number of priorities
      *
     C                   EVAL      RecNotFnd = True
     C                   EVAL      WCounter = Count
      *
      ** Do while counter is greater than avoid priority counter
      ** and profit centre not found
      *
     C                   DOW       WCounter > WAvoidPr
     C                             AND RecNotFnd = True
      *
      ** Chain to LF/SDPRFML1 for Profit Centre
      *
     C                   IF        CSD009 = 'Y'
     C     KFLKEY        CHAIN     @DWREHF                            55
     C                   ELSE
     C     FLKEY         CHAIN     @DWREHF                            55
     C                   ENDIF
      *
      ** If record found, check if profit centre is valid
      *
     C                   IF        *IN55 = '0'
      *
     C                   EVAL      RecNotFnd = False
      *
     C                   CALLB     'AOPRFCR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      DWPCCD        @KEY
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
      ** Invalid Profit Centre, return to calling program with
      ** corresponding error code
      *
     C                   IF        @RTCD <> *BLANKS
     C                   MOVE      '2'           PRTNC
     C                   MOVEL     DWPCCD        PPRFC
     C                   ENDIF
      *
      ** Otherwise, continue processing
      *
     C                   ELSE
      *
      ** If working counter is greater than the avoid priority + 1
      ** then reset default field that it is equal to the counter
      *
     C                   IF        WCounter > WAvoidPr + 1
 
     C     WKPMBK        IFEQ      WCounter
     C                   MOVE      STARS         PBOOK
     C                   ENDIF
 
     C     WKPMTT        IFEQ      WCounter
     C                   MOVE      STARS         PTRTP
     C                   ENDIF
 
     C     WKPMST        IFEQ      WCounter
     C                   MOVE      STARS         PSUTP
     C                   ENDIF
 
     C     WKPMBH        IFEQ      WCounter
     C                   MOVE      STARS         PBRAN
     C                   ENDIF
 
     C     WKPMDT        IFEQ      WCounter
     C                   MOVE      STARS         PDEPT
     C                   ENDIF
 
     C     WKPMUR        IFEQ      WCounter
     C                   MOVE      STARS         PUSER
     C                   ENDIF
 
     C     WKPMAO        IFEQ      WCounter
     C                   MOVE      STARS         PACOF
     C                   ENDIF
 
     C     WKPMCU        IFEQ      WCounter
     C                   MOVE      STARS         PCNUM
     C                   ENDIF
      *
     C     WKLICD        IFEQ      WCounter
     C                   MOVE      STARS         LICD
     C                   ENDIF
      *
     C     WKBNBI        IFEQ      WCounter
     C                   MOVE      STARS         BNBI
     C                   ENDIF
      *
     C     WKCLOC        IFEQ      WCounter
     C                   MOVE      STARS         CLOC
     C                   ENDIF
      *
     C     WKRLOC        IFEQ      WCounter
     C                   MOVE      STARS         RLOC
     C                   ENDIF
      *
     C     WKCNCZ        IFEQ      WCounter
     C                   MOVE      STARS         CNCZ
     C                   ENDIF
      *
     C     WKRNCZ        IFEQ      WCounter
     C                   MOVE      STARS         RNCZ
     C                   ENDIF
      *
     C     WKCSTY        IFEQ      WCounter
     C                   MOVE      STARS         CSTY
     C                   ENDIF
      *
     C     WKGPC1        IFEQ      WCounter
     C                   MOVE      STARS         GPC1
     C                   ENDIF
      *
     C     WKGPC2        IFEQ      WCounter
     C                   MOVE      STARS         GPC2
     C                   ENDIF
      *
     C     WKGPC3        IFEQ      WCounter
     C                   MOVE      STARS         GPC3
     C                   ENDIF
      *
     C     WKGPC4        IFEQ      WCounter
     C                   MOVE      STARS         GPC4
     C                   ENDIF
      *
     C     WKGPC5        IFEQ      WCounter
     C                   MOVE      STARS         GPC5
     C                   ENDIF
      *
      ** Subtract 1 from working counter
      *
     C                   EVAL      WCounter = WCounter - 1
      *
      ** Else, if working counter is less than the avoid priority
      *
     C                   ELSE
      *
      ** If enhancement CSD009 is not installed, setup return codes
      ** and return to calling program
      *
     C                   IF        CSD009 <> 'Y'
      *
      ** If Analytical Accounting is installed, then set return
      ** code to '2' unless enhancement CAC004 is installed
      *
     C     BGN0ST        IFEQ      'Y'
      *
      ** force a return code of '2' and set profit centre field
      ** to blanks
      *
     C                   MOVE      '2'           PRTNC
     C                   MOVEL     *BLANKS       PPRFC
      *
      ** If CAC004 is installed, then use the 'Unallocated Profit
      ** Centre' defined on ICD and set the return code to '0'
      *
     C     CAC004        IFEQ      'Y'
     C/COPY WNCPYSRC,AOPRFMR1C2
     C                   MOVE      '0'           PRTNC
     C                   MOVEL     FTUAPC        PPRFC
     C                   ENDIF
      *
      ** Otherwise, if Analytical Accounting is not installed
      *
     C                   ELSE
      *
      ** Return to caller with error
      *
     C                   MOVE      '1'           PRTNC
     C                   MOVEL     *BLANKS       PPRFC
     C                   ENDIF
      *
     C                   Z-ADD     0             WCounter
      *
      ** Else, continue processing using the 'Best Fit' methodology
      *
     C                   ELSE
      *
      ** Increment avoid priority by 1
      *
     C                   EVAL      WAvoidPr = WAvoidPr + 1
      *
      ** If avoid priority is less than the number of total
      ** priorities, then continue computing for the default
      ** profit centre
      *
     C                   IF        WAvoidPr < Count
      *
      ** For each work parameter, either reset value to original
      ** value or set to asterisks
      *
     C     PBOOK         IFNE      *BLANKS
     C     WKPMBK        ANDGT     WAvoidPr
     C                   MOVE      WBOOK         PBOOK
     C                   ELSE
     C                   MOVE      STARS         PBOOK
     C                   ENDIF
      *
     C     PTRTP         IFNE      *BLANKS
     C     WKPMTT        ANDGT     WAvoidPR
     C                   MOVE      WTRTP         PTRTP
     C                   ELSE
     C                   MOVE      STARS         PTRTP
     C                   ENDIF
      *
     C     PSUTP         IFNE      *BLANKS
     C     WKPMST        ANDGT     WAvoidPr
     C                   MOVE      WSUTP         PSUTP
     C                   ELSE
     C                   MOVE      STARS         PSUTP
     C                   ENDIF
      *
     C     PBRAN         IFNE      *BLANKS
     C     WKPMBH        ANDGT     WAvoidPr
     C                   MOVE      WBRAN         PBRAN
     C                   ELSE
     C                   MOVE      STARS         PBRAN
     C                   ENDIF
      *
     C     PDEPT         IFNE      *BLANKS
     C     WKPMDT        ANDGT     WAvoidPr
     C                   MOVE      WDEPT         PDEPT
     C                   ELSE
     C                   MOVE      STARS         PDEPT
     C                   ENDIF
      *
     C     PUSER         IFNE      *BLANKS
     C     WKPMUR        ANDGT     WAvoidPr
     C                   MOVE      WUSER         PUSER
     C                   ELSE
     C                   MOVE      STARS         PUSER
     C                   ENDIF
      *
     C     PACOF         IFNE      *BLANKS
     C     WKPMAO        ANDGT     WAvoidPr
     C                   MOVE      WACOF         PACOF
     C                   ELSE
     C                   MOVE      STARS         PACOF
     C                   ENDIF
      *
     C     PCNUM         IFNE      *BLANKS
     C     WKPMCU        ANDGT     WAVoidPr
     C                   MOVE      WCNUM         PCNUM
     C                   ELSE
     C                   MOVE      STARS         PCNUM
     C                   ENDIF
      *
     C     LICD          IFNE      *BLANKS
     C     WKLICD        ANDGT     WAvoidPr
     C                   MOVE      WLICD         LICD
     C                   ELSE
     C                   MOVE      STARS         LICD
     C                   ENDIF
      *
     C     BNBI          IFNE      *BLANKS
     C     WKBNBI        ANDGT     WAvoidPr
     C                   MOVE      WBNBI         BNBI
     C                   ELSE
     C                   MOVE      STARS         BNBI
     C                   ENDIF
      *
     C     CLOC          IFNE      *BLANKS
     C     WKCLOC        ANDGT     WAvoidPr
     C                   MOVE      WCLOC         CLOC
     C                   ELSE
     C                   MOVE      STARS         CLOC
     C                   ENDIF
      *
     C     RLOC          IFNE      *BLANKS
     C     WKRLOC        ANDGT     WAvoidPr
     C                   MOVE      WRLOC         RLOC
     C                   ELSE
     C                   MOVE      STARS         RLOC
     C                   ENDIF
      *
     C     CNCZ          IFNE      *BLANKS
     C     WKCNCZ        ANDGT     WAvoidPr
     C                   MOVE      WCNCZ         CNCZ
     C                   ELSE
     C                   MOVE      STARS         CNCZ
     C                   ENDIF
      *
     C     RNCZ          IFNE      *BLANKS
     C     WKRNCZ        ANDGT     WAvoidPr
     C                   MOVE      WRNCZ         RNCZ
     C                   ELSE
     C                   MOVE      STARS         RNCZ
     C                   ENDIF
      *
     C     CSTY          IFNE      *BLANKS
     C     WKCSTY        ANDGT     WAvoidPr
     C                   MOVE      WCSTY         CSTY
     C                   ELSE
     C                   MOVE      STARS         CSTY
     C                   ENDIF
      *
     C     GPC1          IFNE      *BLANKS
     C     WKGPC1        ANDGT     WCounter
     C                   MOVE      WGPC1         GPC1
     C                   ELSE
     C                   MOVE      STARS         GPC1
     C                   ENDIF
      *
     C     GPC2          IFNE      *BLANKS
     C     WKGPC2        ANDGT     WAvoidPr
     C                   MOVE      WGPC2         GPC2
     C                   ELSE
     C                   MOVE      STARS         GPC2
     C                   ENDIF
      *
     C     GPC3          IFNE      *BLANKS
     C     WKGPC3        ANDGT     WAvoidPr
     C                   MOVE      WGPC3         GPC3
     C                   ELSE
     C                   MOVE      STARS         GPC3
     C                   ENDIF
      *
     C     GPC4          IFNE      *BLANKS
     C     WKGPC4        ANDGT     WAvoidPr
     C                   MOVE      WGPC4         GPC4
     C                   ELSE
     C                   MOVE      STARS         GPC4
     C                   ENDIF
      *
     C     GPC5          IFNE      *BLANKS
     C     WKGPC5        ANDGT     WAvoidPr
     C                   MOVE      WGPC5         GPC5
     C                   ELSE
     C                   MOVE      STARS         GPC5
     C                   ENDIF
      *
      ** Set working counter to total number of priorities
      *
     C                   EVAL      WCounter = Count
      *
      ** Otherwise, setup return code and return to calling program
      *
     C                   ELSE
      *
      ** If Analytical Accounting is installed, then set return
      ** code to '2' unless enhancement CAC004 is installed
      *
     C     BGN0ST        IFEQ      'Y'
      *
      ** Set return code to '2' and profit centre field to blanks
      *
     C                   MOVE      '2'           PRTNC
     C                   MOVEL     *BLANKS       PPRFC
      *
      ** If CAC004 is installed, then use the 'Unallocated Profit
      ** Centre' defined on ICD and set reutrn code to '0'
      *
     C     CAC004        IFEQ      'Y'
     C/COPY WNCPYSRC,AOPRFMR1C3
     C                   MOVE      '0'           PRTNC
     C                   MOVEL     FTUAPC        PPRFC
     C                   ENDIF
      *
      ** Else, setup return codes for no profit centre defaulted
      *
     C                   ELSE
      *
      ** Return to caller with error
      *
     C                   MOVE      '1'           PRTNC
     C                   MOVEL     *BLANKS       PPRFC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     PRTNC         IFEQ      *BLANKS
      *
     C                   IF        RecNotFnd = False
     C                             AND COUNT > 0
     C                   MOVE      '0'           PRTNC
     C                   MOVEL     DWPCCD        PPRFC
     C                   ELSE
      *
      ** (Valid Profit Centre not found)
      ** If Analytical Accounting is ON
      *
     C     BGN0ST        IFEQ      'Y'
      *
      ** force a return code of '2'
      *
     C                   MOVE      '2'           PRTNC
     C                   MOVEL     *BLANKS       PPRFC
      *
      ** If CAC004 is also ON, use the 'Unallocated Profit Centre'
      ** and change the return code to '0'
      *
     C                   IF        CAC004 = 'Y'
     C/COPY WNCPYSRC,AOPRFMR1C4
     C                   MOVE      '0'           PRTNC
     C                   MOVEL     FTUAPC        PPRFC
     C                   ENDIF
     C                   ELSE
      *
      ** (Analytical Accounting is OFF)
      *
     C                   MOVE      '1'           PRTNC
     C                   MOVEL     *BLANKS       PPRFC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Seton indicator and exit program
      *
     C                   SETON                                        LR
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
