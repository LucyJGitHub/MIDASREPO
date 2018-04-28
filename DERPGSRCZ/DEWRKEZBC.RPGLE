     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - base rate change')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEZBC - Work with Extract Data (Base Rate Change)        *
      *                                                               *
      *  Component of: DEWRKEDTA                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Last Amend No. CDE001  *CREATE    Date 23Nov99               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D E#BRTT          S              2S 0
     D P#BRTT          S              2S 0
 
      * Set Position Fields
 
     C                   EXSR      SET_POSN
 
      * Return to calling function
 
     C                   RETURN
 
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * SET POSITION FIELDS
      ********************************************************************
     C     SET_POSN      BEGSR
 
      * Update Base Rate Code
 
     C                   MOVE      E#BRTT        P#BRTT
 
      ** If interest rate type signifies forward rate
 
     C     E#IRTP        IFEQ      'F'
 
      ** Update Base Rate
 
     C                   Z-ADD     E#BRTE        P#BRTE
 
      ** Update interest rate
 
     C                   EXSR      UPD_IRAT
     C                   ENDIF
 
      ** If interest rate type signifies current base rate
 
     C     E#IRTP        IFEQ      'C'
 
      ** Update Base Rate
 
     C                   Z-ADD     E#BRTE        P#BRTE
 
      ** Update interest rate
 
     C                   EXSR      UPD_IRAT
     C                   ENDIF
 
      ** If interest rate type signifies actual interest rate
 
     C     E#IRTP        IFEQ      'A'
 
      ** Update interest rate
 
     C                   Z-ADD     E#IRAT        P#IRAT
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * UPDATE CURRENT EFFECTIVE INTEREST RATE
      *********************************************************************
     C     UPD_IRAT      BEGSR
      *
     C                   SELECT
      *
     C     P#SPIN        WHENEQ    ' '
     C     P#SPIN        OREQ      'A'
     C     P#BRTE        ADD       P#RTSP        P#IRAT
      *
     C     P#SPIN        WHENEQ    'S'
     C     P#BRTE        SUB       P#RTSP        P#IRAT
      *
     C     P#SPIN        WHENEQ    'P'
     C     P#RTSP        DIV       100           W#W119           11 9
     C     P#BRTE        MULT(H)   W#W119        P#IRAT
      *
     C                   ENDSL
      *
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         30
      *
      * INPUTS
      ** Rate/Spread
      ** Spread Ind
     C                   PARM                    P#RTSP           11 7
     C                   PARM                    P#SPIN            1
      ** Base Rate Code
      ** Base Rate
      ** Interest Rate
      ** Interest Rate Type
     C                   PARM                    E#BRTT            2 0
     C                   PARM                    E#BRTE           11 7
     C                   PARM                    E#IRAT           11 7
     C                   PARM                    E#IRTP            1
      *
      * OUTPUTS
      ** Base Rate Code
      ** Base Rate
      ** Interest/Discount Rate
     C                   PARM                    P#BRTT            2 0
     C                   PARM                    P#BRTE           11 7
     C                   PARM                    P#IRAT           11 7
 
     C                   ENDSR
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR_WK
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
