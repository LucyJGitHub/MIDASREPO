     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SF Update Global user')
      *****************************************************************
      *                                                               *
      *  Midas-  Security Profile Facility                            *
      *                                                               *
      *  SF000041 - Midas SF Update Global user                       *
      *                                                               *
      *  Function: This program copies the global rights from an      *
      *  I/C       existing user to the new one.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSD086             Date 17Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG13895           Date 15May07               *
      *                 BUG14103           Date 18Jun07               *
      *                 241013 *CREATE     Date 12Dec06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD086 - Overridable Errors (Recompile)                      *
      *  BUG13895 - Copy user failed. Pgm tried to delete a           *
      *             non-existing record. Applied by 246242            *
      * BG13842 - Pgm doesn't handle end-of-file, so falls over       *
      *         - Should also use commitment control. Annotated as    *
      *           BUG14103                                            *
      *  246242 - Check if READ is successful.                        *
      *  BUG14103 - Applied Fix BUG13842 and 246242                   *
      *  241013 - Copy the global rights of the user.                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
     FGZMUSERL0 UF A E           K DISK
     F                                     COMMIT                                           BUG14103
     FGPMBRBS   UF A E           K DISK
     F                                     COMMIT                                           BUG14103
     FGPMACBR1  UF A E           K DISK
     F                                     COMMIT                                           BUG14103
      *
      ** RUNDAT data area.
      *
     D RUNDAT          DS
     D  AGMRDT                 1      7
     D  AGRDNB                 8     10P 0
     D  AGSUC                 11     11
     D  AGDFF                 12     12
     D  AGMBIN                13     13
      *
      ** Parameter variables for access object GPAOSVAL
     D pSysVal01       S             20    INZ(*BLANKS)
     D pSysValCurS01   S            200    INZ(*BLANKS)
     D pSysVal02       S             20    INZ(*BLANKS)
     D pSysValCurS02   S            200    INZ(*BLANKS)
     D pSysVal03       S             20    INZ(*BLANKS)
     D pSysValCurS03   S            200    INZ(*BLANKS)
     D pSysVal04       S             20    INZ(*BLANKS)
     D pSysValCurS04   S            200    INZ(*BLANKS)
     D pSysVal05       S             20    INZ(*BLANKS)
     D pSysValCurS05   S            200    INZ(*BLANKS)
     D pSysVal06       S             20    INZ(*BLANKS)
     D pSysValCurS06   S            200    INZ(*BLANKS)
     D pSysVal07       S             20    INZ(*BLANKS)
     D pSysValCurS07   S            200    INZ(*BLANKS)
     D pSysVal08       S             20    INZ(*BLANKS)
     D pSysValCurS08   S            200    INZ(*BLANKS)
     D pSysVal09       S             20    INZ(*BLANKS)
     D pSysValCurS09   S            200    INZ(*BLANKS)
     D pSysVal10       S             20    INZ(*BLANKS)
     D pSysValCurS10   S            200    INZ(*BLANKS)
 
     C                   EXSR      INIT
     C     UPDGLOBAL     IFEQ      'Y'
     C                   EXSR      INUSR
     C                   EXSR      INBRA
     C                   EXSR      INACT
     C                   ENDIF
     C                   MOVE      '1'           *INLR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT      - Initial subroutine                                *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    RFUSR            10
     C                   PARM                    NWUSR            10
     C                   PARM                    NEWDSC           25
      *
      ** GET RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      **  Access SAR details file to see if CGL008 SAR is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CGL008'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL008            1
     C                   ELSE
     C                   MOVE      'N'           CGL008
     C                   ENDIF
      *
      ** Get Fiscal End Month
     C                   EVAL      pSysVal01     = 'GlobRightsUsrUpdate'
 
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *Blank        pRtCd             7
     C                   PARM                    pSysVal01
     C                   PARM                    pSysValCurS01
     C                   PARM                    pSysVal02
     C                   PARM                    pSysValCurS02
     C                   PARM                    pSysVal03
     C                   PARM                    pSysValCurS03
     C                   PARM                    pSysVal04
     C                   PARM                    pSysValCurS04
     C                   PARM                    pSysVal05
     C                   PARM                    pSysValCurS05
     C                   PARM                    pSysVal06
     C                   PARM                    pSysValCurS06
     C                   PARM                    pSysVal07
     C                   PARM                    pSysValCurS07
     C                   PARM                    pSysVal08
     C                   PARM                    pSysValCurS08
     C                   PARM                    pSysVal09
     C                   PARM                    pSysValCurS09
     C                   PARM                    pSysVal10
     C                   PARM                    pSysValCurS10
      *
     C                   MOVE      'Y'           UPDGLOBAL         1
     C                   IF        pRtCd      =  *BLANKS
     C                   MOVEL     pSysValCurS01 UPDGLOBAL
     C                   ENDIF
     C                   MOVE      *BLANKS       RECI
     C     RFUSR         CHAIN     MUSERDDF                           22
     C     *IN22         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INUSR     - Set up new user                                   *
      *                                                               *
      *****************************************************************
     C     INUSR         BEGSR
      *
     C                   MOVE      *BLANKS       RECI
     C     NWUSR         CHAIN     MUSERDDF                           22
     C     *IN22         IFEQ      '1'
     C     RFUSR         CHAIN     MUSERDDF                           22
     C                   MOVE      NWUSR         USRP
     C                   MOVEL     NEWDSC        USER1
     C                   MOVE      AGRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   TIME                    TIMEP             6 0
     C                   Z-ADD     TIMEP         LCT
     C                   Z-ADD     0             SOCNT
      *
      ** If feature Security on Journal Entry Input is *ON
      *
     C     CGL008        IFEQ      'Y'
      *
      ** Set-up the new fields.
      *
     C                   MOVE      'N'           ALACOD
     C                   MOVE      'Z'           USRLVL
     C                   MOVE      'N'           REFFLG
     C                   MOVE      NWUSR         REFUSR
     C                   ENDIF
      *
     C                   WRITE     MUSERDDF
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INBRA     - Set up valid branches                             *
      *                                                               *
      *****************************************************************
     C     INBRA         BEGSR
     C     NWUSR         CHAIN     GPMBRBS                            40
     C     *IN40         IFEQ      '1'
     C     RFUSR         CHAIN     GPMBRBS                            40
     C     *IN40         IFEQ      '0'
     C                   MOVE      'D'           RECI
     C                   MOVE      NWUSR         USRP
     C                   WRITE     MBRBSDDF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INACT     - Set up Action codes                               *
      *                                                               *
      *****************************************************************
     C     INACT         BEGSR
     C     NWUSR         SETLL     GPMACBR1
     C                   READ      GPMACBR1                               80
     C     NWUSR         DOWEQ     USRP
     C     *IN80         ANDEQ     '0'                                                      BUG14103
     C                   DELETE    MACBRDDF
     C                   READ      GPMACBR1                               80
     C                   ENDDO
     C     RFUSR         SETLL     GPMACBR1
     C                   READ      GPMACBR1                               80
     C     RFUSR         DOWEQ     USRP
     C     *IN80         ANDEQ     '0'                                                      BUG14103
     C                   MOVE      NWUSR         USRP
     C                   MOVE      'D'           RECI
     C                   WRITE     MACBRDDF
     C                   READ      GPMACBR1                               80
     C                   ENDDO
     C                   ENDSR
      *
