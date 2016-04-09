     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Funds Transfer Party Identificatio')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSFTPI - Access Funds Transfer Party Identification       *
      *                                                               *
      *  Function:  This module identifies FT parties (as a customer).*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FACNUM     IF   E           K DISK    RENAME(ACCNTABF:ACNUMABF)
     F                                     INFSR(*PSSR)
      * Retail accounts
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      * Meridian Export Attributes
     D FTPI          E DS                  EXTNAME(MXFTPIPD)
 
 
     D                 DS
     D  A_NOSID                1      5
     D  A_NOSTN                1      2
     D  A_CCY                  1      3
     D  A_NOSTF                4      5
 
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** External DS for NOSTRO details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D @ACCD           S             10A                                                      CGL029
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        PICCY
     C                   MOVEL     I#LFD2        PIPRTT
     C                   MOVEL     I#LFD3        PIPRTL
 
      * Determine party based on party type
 
     C                   MOVEL     *BLANK        PICUST
 
     C     PIPRTT        CASEQ     'C'           P_CUSTOMER
     C     PIPRTT        CASEQ     'R'           P_ACNUMBER
     C     PIPRTT        CASEQ     'P'           P_ACCOUNT
     C     PIPRTT        CASEQ     'F'           P_FULLNOST
     C     PIPRTT        CASEQ     'N'           P_NOST
     C                   ENDCS
 
      * Set up output data
 
     C                   EVAL      InData = FTPI
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * PARTY IS CUSTOMER (NUMBER)
      ********************************************************************
     C     P_CUSTOMER    BEGSR
 
     C                   MOVEL     PIPRTL        PICUST
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * PARTY IS (RETAIL) ACCOUNT NUMBER
      ********************************************************************
     C     P_ACNUMBER    BEGSR
 
     C                   MOVEL     PIPRTL        A_ACNO           10
     C                   TESTN                   A_ACNO               9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     A_ACNO        ACNO
     C     ACNO          CHAIN     ACNUMABF                           99        *
     C     *IN99         IFEQ      '0'
     C                   MOVEL     CNUM          PICUST
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * PARTY IS ACCOUNT
      ********************************************************************
     C     P_ACCOUNT     BEGSR
 
     C                   MOVEL     PIPRTL        PICUST
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * PARTY IS FULL NOSTRO ID
      ********************************************************************
     C     P_FULLNOST    BEGSR
 
     C                   MOVEL     PIPRTL        A_NOSID
     C                   TESTN                   A_NOSTF              9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     A_CCY         @CYCD
     C                   MOVEL     A_NOSTF       @NONB
     C                   EXSR      ACSNOST
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A7CUST        PICUST
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * PARTY IS NOSTRO NUMBER
      ********************************************************************
     C     P_NOST        BEGSR
 
     C                   MOVEL     PIPRTL        A_NOSID
     C                   TESTN                   A_NOSTN              9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     PICCY         @CYCD
     C                   MOVEL     A_NOSTN       @NONB
     C                   EXSR      ACSNOST
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A7CUST        PICUST
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * ACCESS NOSTRO
      ********************************************************************
     C     ACSNOST       BEGSR
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM                    @CYCD             3
     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       @ACCD                                        CGL029
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM                    @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
