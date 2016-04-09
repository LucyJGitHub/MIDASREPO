     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Determine Future Deal Status& Change Type')   *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  ZAFUTSTATP - DETERMINE FUTURE DEAL STATUS & CHANGE TYPE      *
      *                                                               *
      *  This routine sets according to current status, action and    *
      *  and whether authorisationn or re-authorisation is required:  *
      *                                                               *
      *  i) FUTURE DEAL STATUS                                        *
      *  Its values are:                                              *
      *                      'C' COMPLETE                             *
      *                      'A' AUTHORIZED                           *
      *                      'R' REAUTHORIZATION REQUIRED             *
      *                      'M' MATURED                              *
      *                                                               *
      *  ii) CHANGE TYPE (also determined by future deal status)      *
      *  The change type controls what will happen in the             *
      *  dealing database update function.                            *
      *  Its values are:                                              *
      *                      'I' INSERTION                            *
      *                      'A' AMENDMENT                            *
      *                      'R' REVERSAL                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG27841           Date 09Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247266             Date 21Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 195753             Date 15Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 29Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 136435             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG27841 - Status changes to Requires Reauthorisation        *
      *             during Delete Action.                             *
      *  247266 - When deal is reversed, saved as unauthorised.       *
      *  195753 - In amendment, authorised only if the old status of  *
      *           the deal was authorised.                            *
      *  CAP051 - Automatic Authorisation                             *
      *  136435 - SWIFT pay messages generated on unauthorized trans  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      /EJECT
     C*****************************************************************
     C*
     C**  DETERMINE FUTURE DEAL STATUS
     C*
     C                   EXSR      FUTSTS
     C*
     C**  DETERMINE CHANGE TYPE
     C*
     C                   EXSR      CHGTYP
     C*
     C** RETURN
     C*
     C                   RETURN
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* FUTSTS - DETERMINE FUTURE DEAL STATUS                        *
     C*                                                              *
     C****************************************************************
     C     FUTSTS        BEGSR
     C*
     C*  If insert and MM authorization required
     C*  status will be complete
     C*
     C     @ACTN         IFEQ      'I'
     C     BNMMAU        ANDEQ     'Y'
     C                   MOVE      'C'           @FSTS
     C                   END
     C*
     C*  If insert and no MM authorization required
     C*  future status will be authorized
     C*
     C     @ACTN         IFEQ      'I'
     C     BNMMAU        ANDNE     'Y'
     C                   MOVE      'A'           @FSTS
     C                   END
     C*
     C*  If amend and status is currently complete
     C*  future status will be complete
     C*
     C     @ACTN         IFEQ      'A'
     C     @CSTS         ANDEQ     'C'
     C                   MOVE      'C'           @FSTS
     C                   END
     C*
     C*  If amend and no MM reauthorization after amend
     C*  and current status is authorized, status will be unchanged
     C*
     C     @ACTN         IFEQ      'A'
     C     BNMMRA        ANDEQ     'N'
     C*****@CSTS         ANDEQ     'A'                                          CAP051
     C     @CSTS         ANDEQ     'A'                                          195753
     C                   MOVE      'A'           @FSTS
     C                   END
     C*
     C*  If amend and MM reauthorization after amend
     C*  future status will be reauthorization required
     C*
     C     @ACTN         IFEQ      'A'
     C     BNMMRA        ANDEQ     'Y'
     C     @CSTS         IFEQ      'R'
     C     @CSTS         OREQ      'A'
     C                   MOVE      'R'           @FSTS
     C                   END
     C                   END
     C*
     C*  If authorizing, future status will be authorized
     C*
     C     @ACTN         IFEQ      'X'
     C                   MOVE      'A'           @FSTS
     C                   END
     C*
     C*  If deleting, status will not be changed
     C*
     C     @ACTN         IFEQ      'D'
     C*****@CSTS         IFEQ      'R'                                               247266 BUG27841
     C**********         MOVE      'A'           @FSTS                               247266 BUG27841
     C**********         ELSE                                                        247266 BUG27841
     C                   MOVE      @CSTS         @FSTS
     C**********         ENDIF                                                       247266 BUG27841
     C                   END
     C                   ENDSR
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CHGTYP -  DETERMINE CHANGE TYPE                               *
     C*                                                               *
     C*****************************************************************
     C     CHGTYP        BEGSR
     C*
     C*---------------------------------------------------------------
     C*
     C* If INSERTION
     C*
     C     @ACTN         IFEQ      'I'
     C*
     C* If no MM authorization required, change type will be insert
     C*
     C     BNMMAU        IFNE      'Y'
     C     @FSTS         ANDEQ     'A'
     C                   MOVE      'I'           @CHTP
     C                   END
     C*
     C* If MM authorization required, change type will be blank
     C* (i.e. no dealing database updates)
     C*
     C     BNMMAU        IFEQ      'Y'
     C     @FSTS         ANDEQ     'C'
     C                   MOVE      *BLANKS       @CHTP
     C                   END
     C*
     C                   END
     C*
     C*---------------------------------------------------------------
     C*
     C* If AMENDMENT
     C*
     C     @ACTN         IFEQ      'A'
     C*
     C* If both current and future status is complete,
     C* change type will be blank.
     C* (i.e. no dealing database updates)
     C*
     C     @CSTS         IFEQ      'C'
     C     @FSTS         ANDEQ     'C'
     C                   MOVE      *BLANKS       @CHTP
     C                   END
     C*                                                                         136435
     C**If*deal*being*amended***********************************************    136435
     C**change*type*will*be*amend*******************************************    136435
     C* If deal is being amended and authorization is still required            136435
     C* change type will be blank.                                              136435
     C* (i.e. no dealing database updates)                                      136435
     C*                                                                         136435
     C     @CSTS         IFEQ      'A'                                          136435
     C     @FSTS         ANDEQ     'R'                                          136435
     C     BNMMRA        ANDEQ     'Y'                                          136435
     C*****@CSTS         OREQ      'A'                                          136435
     C*****@FSTS         ANDEQ     'A'                                          136435
     C*****BNMMRA        ANDNE     'Y'                                          136435
     C     @CSTS         OREQ      'R'                                          136435
     C     @FSTS         ANDEQ     'R'                                          136435
     C     BNMMRA        ANDEQ     'Y'                                          136435
     C                   MOVE      *BLANKS       @CHTP                          136435
     C                   END                                                    136435
     C*                                                                         136435
     C* If deal being amended and no authorization                              136435
     C* change type will be amend                                               136435
     C*                                                                         136435
     C     @CSTS         IFEQ      'A'                                          136435
     C**** @FSTS         ANDEQ     'A'                                   136435 CAP051
     C     BNMMRA        ANDNE     'Y'                                          136435
     C                   MOVE      'A'           @CHTP
     C                   END
     C*
     C                   END
     C*
     C*---------------------------------------------------------------
     C*
     C* If DELETION
     C*
     C     @ACTN         IFEQ      'D'
     C*
     C* If current status is complete, change type will be blank
     C* (i.e. no dealing database updates)
     C* Otherwise, change type will be reversal
     C*
     C     @CSTS         IFEQ      'C'
     C                   MOVE      *BLANKS       @CHTP
     C                   ELSE
     C                   MOVE      'R'           @CHTP
     C                   END
     C                   END
     C*
     C*---------------------------------------------------------------
     C*
     C* If AUTHORIZATION
     C*
     C     @ACTN         IFEQ      'X'
     C*
     C* If status is changing from complete to authorized
     C* change type will be insert
     C*
     C     BNMMAU        IFEQ      'Y'
     C     @CSTS         ANDEQ     'C'
     C     @FSTS         ANDEQ     'A'
     C                   MOVE      'I'           @CHTP
     C                   END
     C*
     C* If re-authorization is occurring
     C* change type will be amend
     C*
     C     BNMMAU        IFEQ      'Y'
     C     BNMMRA        ANDEQ     'Y'
     C     @CSTS         ANDEQ     'R'
     C     @FSTS         ANDEQ     'A'
     C                   MOVE      'A'           @CHTP
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      *
      ** Action
     C                   PARM                    @ACTN             1
      *
      ** Current Deal Status
     C                   PARM                    @CSTS             1
      *
      ** MM authorisation required
     C                   PARM                    BNMMAU            1
      *
      ** MM reauthorize amended deals
     C                   PARM                    BNMMRA            1
      *
      ** OUTPUT
      *
      ** Future Deal Status
     C                   PARM                    @FSTS             1
      *
      ** Change type
     C                   PARM                    @CHTP             1
      *
     C                   ENDSR
     C****************************************************************
