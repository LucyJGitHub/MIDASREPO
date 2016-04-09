     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO IBAN calculate/validate check digit')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  AOIBANR9 - Midas AO IBAN calculate/validate check digit      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR940312           Date 24Mar12               *
      *  Prev Amend No. CFT044  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR940312 - Serious Midas error occurred in AMAD              *
      *  CFT044 - Portuguese IBAN                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR  - Initialise                                         *
      *  Modul97 - Set the two last digits with Mudulo 97             *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ! F-specs                              !
      ** ! =======                              !
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ! D-specs                              !
      ** ! =======                              !
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ! Named constants                      !
      ** ! ===============                      !
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ! Arrays and Data Structures           !
      ** ! ==========================           !
      ** +--------------------------------------+
      *
     D*#IIBAN***       S             34                                                     AR940312
     D #IIBAN          S             21                                                     AR940312
     D #OIBAN          S             34
      *
     D                 DS
      * Work data structure for 'old' NIB routine
     D**##IBAN**               1     34                                                     AR940312
     D  ##IBAN                 1     21                                                     AR940312
     D  ##NIBBK                1      4
     D  ##NIBBR                5      8
     D  ##ZERO                 9      9
     D  ##ACNO                10     19
     D  ##CHKD2               20     21
     D  ##NIBA                 1     21
 
      ** +--------------------------------------+
      ** ! Declared variables                   !
      ** ! ==================                   !
      ** +--------------------------------------+
      **  Array for Modulo 97 - Containing weighing
     D @WI             S              2  0 DIM(21) CTDATA PERRCD(21)
      *
      **  Array for Modulo 97 - Containing character number            IOD
     D @I              S              3  0 DIM(21)
      *
      **  Array for Modulo 97 - Containing the window field cumul
     D @AI             S              1  0 DIM(21)
      *
      *
      **  Array for Modulo 97 - Containing the window field cumul
     D @AIC            S              1    DIM(21)
      *
     D @RUN            S              1
      *
     D P@RTCD          S              7
     D Y               S              2  0
     D SUM             S              5  0
     D D               S              4  0
     D S               S              2  0
     D TOT             S              2  0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** !                                                                !
      ** ! Initial processing is performed automatically: the *INZSR is   !
      ** ! executed at program activation.                                !
      ** !                                                                !
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      **  Define data area LDA
     C     *DTAARA       DEFINE                  LDA
      *
     C                   MOVEL     #IIBAN        ##IBAN
      *
      **  Calculate last 2 digits
     C                   EXSR      Modul97
      *
     C                   MOVEL     ##IBAN        #OIBAN
      **  Return to calling program
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      * Modul97 - Set the two last digits with Modulo 97              *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Modul97       BEGSR
      *
      **  Reset check digit field
     C                   MOVE      *BLANKS       ##CHKD2
      *
      **  Move NIB part of IBAN (positions 5 - 25) into work fields
     C                   MOVEA     ##NIBA        @AIC
     C                   MOVE      @AIC          @AI
      *
      ** Multiply each digit by the corresponding weighing
     C                   Z-ADD     1             Y
     C     Y             DOUEQ     21
     C     @AI(Y)        MULT      @WI(Y)        @I(Y)
     C                   ADD       1             Y
     C                   ENDDO
      *
      ** Sum the results
     C                   Z-ADD     1             Y
     C                   Z-ADD     0             SUM
     C     Y             DOUEQ     21
     C                   ADD       @I(Y)         SUM
     C                   ADD       1             Y
     C                   ENDDO
      *
      ** Divide the Sum by 97
     C     SUM           DIV       97            D
     C                   MVR                     S
      *
      ** Subtract 98 from the last subtract result to have the Check Digit
     C     98            SUB       S             TOT
     C                   MOVE      TOT           ##CHKD2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD
     C                   PARM                    #IIBAN
     C                   PARM                    #OIBAN
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
**CTDATA @WI
731789386245531550054934817627900930031001
