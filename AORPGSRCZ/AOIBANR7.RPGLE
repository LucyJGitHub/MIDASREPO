     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO IBAN derive ISO country code for branch')     *
      *****************************************************************
      *                                                               *
      *  Midas - Access Object                                        *
      *                                                               *
      *  AOIBANR7 - IBAN Derive ISO Country Code for Branch           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW213             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3644            Date 12Jul04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004  *CREATE    Date 14Jul99               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CGL029 - Increase Account Code to 10 digits                  *
      *   CFT004 - International Bank Account Number                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L     FUNCTION OF INDICATORS                      *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
     D*ESTART
      ****************************************************************
      * Description     : Copyright notice for inclusion in all programs
      ********************************************************************
      /EJECT
     D*ISTART
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      * RUNDAT DATA AREA
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      * Define Access Object Branch detail
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      ** LOCATION DETAILS ACCESSED VIA ACCESS PROGRAM
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** BANK DETAILS ACCESSED VIA ACCESS PROGRAM
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** Country Codes table data
      *
     D MEISOC        E DS                  EXTNAME(MEISOCPD)                                  CSW213
      ** ISO country codes                                                                    CSW213
      *                                                                                       CSW213
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     I* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
      *****************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7            O:Return code
     C                   PARM                    P@BRCH            3            I:BranchCode
     C                   PARM                    P@ISOC            2            O:ISO Countr
      *****************************************************
      *MAIN
     C                   MOVE      *BLANKS       P@ISOC
      *
      * Determine if a multi-branch environment
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     AGMBIN        IFEQ      'Y'                                          Multi-Branch
      *
      * Get Branch details
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      P@BRCH        @DSNB             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      '*ERROR '     P@RTCD
     C                   RETURN
     C                   ENDIF
      *
     C* Get Country Code using Branch Location Code
     C     A8LCCD        IFNE      *BLANKS
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      A8LCCD        @DVKEY            3
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      '*ERROR '     P@RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   MOVE      DVCNCD        WKCNCD            2
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     AGMBIN        IFEQ      'N'                                          Non Multi-Br
     C     A8LCCD        OREQ      *BLANKS                                      No Location
      *
      * Use System Location & Country
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      '*ERROR '     P@RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   MOVE      BJCNCD        WKCNCD
     C                   ENDIF
      *                                                                                       CSW213
      ** Check if SWIFT 2013 is switched on                                                   CSW213
      *                                                                                       CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       @RTCD                                        CSW213
      *                                                                                       CSW213
     C                   IF        @RTCD = 'CSW2013'                                          CSW213
     C                   MOVE      'Y'           CSW213            1                          CSW213
     C                   ELSE                                                                 CSW213
     C                   MOVE      'N'           CSW213                                       CSW213
     C                   ENDIF                                                                CSW213
      *
      * Access Country
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WKCNCD        @CNCD             2
     C     SDCTRY        PARM      SDCTRY        DSFDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      '*ERROR '     P@RTCD
     C                   RETURN
     C                   ENDIF
      * Set Output Parameter : ISO Country Code
     C                   MOVE      A4ISOC        P@ISOC
      *                                                                                       CSW213
      ** Call SWIFT ISO Country Codes access object if CSW213 = ON                            CSW213
      *                                                                                       CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   CALL      'AOMSOCR0'                                                 CSW213
     C                   PARM      *BLANKS       @RTCD                                        CSW213
     C                   PARM      '*KEY   '     @OPTN                                        CSW213
     C                   PARM      P@ISOC        @Isoc             2                          CSW213
     C     MEISOC        PARM      MEISOC        DSFDY                                        CSW213
      *                                                                                       CSW213
      ** If with IBAN Country Code retrieved from MEISOCPD,                                   CSW213
      ** it will now become the new P@ISOC                                                    CSW213
      *                                                                                       CSW213
     C     @RTCD         IFEQ      *BLANKS                                                    CSW213
     C     M3IBAC        ANDNE     *BLANKS                                                    CSW213
     C                   MOVE      M3IBAC        P@ISOC                                       CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
     C                   ENDIF                                                                CSW213
      *
      * Invalid Field
     C     AGMBIN        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       P@ISOC
     C                   MOVE      '*ERROR '     P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA CPY@
(c) Finastra International Limited 2001
