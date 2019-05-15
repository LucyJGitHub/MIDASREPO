     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas BoE SDBRCHPD Trigger - Extract File For BRCH')   *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY009090 - Midas BOE Trigger Program                         *
      *                                                               *
      *  Function:  This program creates/deletes extract file for     *
      *             branch                                            *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Called By: SCTRIGGER                                         *
      *                                                               *
      *  Last Amend No. MD050385*CREATE    Date 07May18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050385 - Error in COB when initialisation program BYC0001  *
      *             is run before creation of new branch              *
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

     D BRCHFormat    E DS                  EXTNAME(SDBRCHPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D RUNDAT        E DS                  EXTNAME(RUNDAT)

      * 'Before' variables for SQL key details and update checking
     D PFlag           S              1
     D PRtCd           S              1
     D LLN007          S              1

      *****************************************************************
     C/EJECT
      *****************************************************************

      * Entry parameters

     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C                   EVAL      LLN007 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'LLN007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RtCd = *BLANKS
     C                   EVAL      LLN007 = 'Y'
     C                   ENDIF

     C                   IF        LLN007 = 'Y'
     C                             AND AGMBIN = 'Y'

      * Recover before and after image
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000

     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000

      * Trigger event types:
      * '1'=Insert, '2'=Delete

      * Insert
     C                   IF        TrgEvent = '1'
     C                   EVAL      BRCHFormat = I#AIMG
     C                   CALL      'BYC9090'
     C                   PARM      'I'           PFlag
     C                   PARM                    A8BRCD
     C                   PARM      *BLANKS       PRtCd
     C                   ENDIF

      * Delete
     C                   IF        TrgEvent = '2'
     C                   EVAL      BRCHFormat = I#BIMG
     C                   CALL      'BYC9090'
     C                   PARM      'D'           PFlag
     C                   PARM                    A8BRCD
     C                   PARM      *BLANKS       PRtCd
     C                   ENDIF
      *
      * Check for successful completion
     C                   IF        PRtCd = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF
     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE

     C                   SETON                                        LR
     C                   RETURN

     C                   ENDSR

      **---------------------------------------------------------------
      *****************************************************************
