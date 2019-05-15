     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - ME')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBME - Global Updates - ME                               *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022168 *CREATE   Date 12Sep13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022168 - GZMEBIB3PD Replication                            *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
      ** Switchable Feature Details Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A
 
      ** Switchable Features
     D CFT050          S              1A
 
      ** ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      ** Recover before and after image
 
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000
 
 
      ** Global Updates - BEFORE/AFTER image
      ** TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE
 
     C     TRGEVENT      IFEQ      '1'
     C                   MOVEL     *BLANK        I#BIMG
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'
     C                   MOVEL     *BLANK        I#AIMG
     C                   ENDIF
 
      ** Error Message
 
     C                   MOVEL     O#ZONE        I#ZONE
     C                   MOVEL     'Y'           I#TRAP
 
      ** Determine updates
 
     C                   EXSR      DET_UPDATES
 
     C                   MOVEL     'B'           I#BFAF
     C                   DO        2
 
     C     P_Before      IFEQ      'Y'
     C     I#BFAF        ANDEQ     'B'
     C     P_After       OREQ      'Y'
     C     I#BFAF        ANDEQ     'A'
 
      ** Add other cases when adding new PF's
 
     C     PFLNAME       CASEQ     'MEBIB3PD'    GLOB_MEBIB3PD
     C                   ENDCS
 
     C                   ENDIF
 
     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      *                                                               *
      * Global Updates - SWIFTRef BANK DIRECTORY Plus                 *
      *                                                               *
      *****************************************************************
     C     GLOB_MEBIB3PD BEGSR
     C                   IF        CFT050 = 'Y'
      /COPY GPCPYSRCG,GPMEBIB3PD
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * DET_UPDATES - Determine Updates Subroutine                    *
      * Calls: None                                                   *
      * Called by: Main                                               *
      *                                                               *
      *****************************************************************
     C     DET_UPDATES   BEGSR
 
     C                   CALL      'GPDETGUPD'
     C                   PARM                    I#ZONE           10
     C                   PARM      PFLNAME       I#FILE           10
     C                   PARM                    I#BIMG
     C                   PARM                    I#AIMG
     C                   PARM      'N'           P_Before          1
     C                   PARM      'N'           P_After           1
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine called automatically              *
      *          at program start                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
      ** Get Zone
 
     C/COPY GOCPYSRC,GOGETZONE
 
      ** Check if CFT050 is enabled.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT050'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   EVAL      CFT050 = 'N'
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CFT050 = 'Y'
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = PSARD
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L  E R R O R  C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
