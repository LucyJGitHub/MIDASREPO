     H DEBUG
     H COPYRIGHT ('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Batch Item Convert - Extension')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITP2CT - GL Batch Item Convert - Extension                *
      *                                                               *
      *  Function:  This function converts the file format details    *
      *             into screen format ready for display.             *
      *                                                               *
      *  Component of: SP8GL0004 Service Program                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Extension File Screen Data Structure
     D BITPExScnFmt  E DS                  EXTNAME(GLBPRXPD)
 
      ** Input Parameter File Data Structure
     D BITPExFilFmt  E DS                  EXTNAME(GLJPX1PD)
 
      ** External Data Structure for Currency Details File
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Second Data Structure for Access Programs - Long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Format amount returned by module ZFRPED
     D ZOUTPUT         DS
     D  ZOUT22                 1     22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZOUT18                18     18
     D  ZOUT19                19     19
     D  ZNEG                  21     21
 
      ** Standard *Entry Parameters
     D PRetCodeIn      S             10
     D PBJDFIN         S              1
     D PBJCYCD         S              3
 
      ** Parameters for module ZFRPED
     D  ZFLD15         S             15  0
     D  ZDECS          S              1  0
     D  ZECODE         S              1
     D  ZOUT25         S             25
 
      ** Parameters for module AOCURRR0
     D  @CURR          S              3
 
      /EJECT
      *****************************************************************
      *                 M A I N    P R O C E S S I N G                *
      *****************************************************************
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
 
      ** Initialize
     C                   EXSR      SRInit
 
      ** Convert
     C                   EXSR      SRConvert
 
      ** Exit from program
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      * SRInit - Program Initialization SubRoutine                    *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Clear Output Data Structure
     C                   CLEAR                   BITPExScnFmt
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRConvert - Convert Fields SubRoutine                         *
      *****************************************************************
     C     SRConvert     BEGSR
 
      ** Character Fields
     C                   MOVEL     JECOC1        LLLXCOC1
     C                   MOVEL     JEIDC1        LLLXIDC1
     C                   MOVEL     JEIDE1        LLLXIDE1
     C                   MOVEL     JECOC2        LLLXCOC2
     C                   MOVEL     JEIDC2        LLLXIDC2
     C                   MOVEL     JEIDE2        LLLXIDE2
     C                   MOVEL     JECOC3        LLLXCOC3
     C                   MOVEL     JEIDC3        LLLXIDC3
     C                   MOVEL     JEIDE3        LLLXIDE3
     C                   MOVEL     JEDCI1        LLLXDCI1
     C                   MOVEL     JEDCI2        LLLXDCI2
     C                   MOVEL     JEDCI3        LLLXDCI3
 
      ** Numeric Fields
     C                   Z-ADD     *ZEROS        ZDECS
     C                   MOVE      'J'           ZECODE
 
     C                   Z-ADD     JEOPC1        ZFLD15
     C                   EXSR      SRCall
     C                   IF        ZOUT20 <> *BLANKS
     C                   IF        ZOUT18 = *BLANKS
     C                   EVAL      ZOUT18 = '0'
     C                   ENDIF
     C                   IF        ZOUT19 = *BLANKS
     C                   EVAL      ZOUT19 = '0'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      ZOUT20        LLLXOPC1
 
     C                   Z-ADD     JEOPC2        ZFLD15
     C                   EXSR      SRCall
     C                   IF        ZOUT20 <> *BLANKS
     C                   IF        ZOUT18 = *BLANKS
     C                   EVAL      ZOUT18 = '0'
     C                   ENDIF
     C                   IF        ZOUT19 = *BLANKS
     C                   EVAL      ZOUT19 = '0'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      ZOUT20        LLLXOPC2
 
     C                   Z-ADD     JEOPC3        ZFLD15
     C                   EXSR      SRCall
     C                   IF        ZOUT20 <> *BLANKS
     C                   IF        ZOUT18 = *BLANKS
     C                   EVAL      ZOUT18 = '0'
     C                   ENDIF
     C                   IF        ZOUT19 = *BLANKS
     C                   EVAL      ZOUT19 = '0'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      ZOUT20        LLLXOPC3
 
      ** Amount Fields
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'L'           ZECODE
 
     C                   IF        JEPTA1 = 0
     C                   EVAL      LLLXPTA1 = *BLANKS
     C                   ELSE
 
     C                   Z-ADD     JEPTA1        ZFLD15
     C                   EXSR      SRCall
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        LLLXPTA1
     C                   ELSE
     C                   MOVE      ZOUT20        LLLXPTA1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        JEPTA2 = 0
     C                   EVAL      LLLXPTA2 = *BLANKS
     C                   ELSE
 
     C                   Z-ADD     JEPTA2        ZFLD15
     C                   EXSR      SRCall
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        LLLXPTA2
     C                   ELSE
     C                   MOVE      ZOUT20        LLLXPTA2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        JEPTA3 = 0
     C                   EVAL      LLLXPTA3 = *BLANKS
     C                   ELSE
 
     C                   Z-ADD     JEPTA3        ZFLD15
     C                   EXSR      SRCall
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        LLLXPTA3
     C                   ELSE
     C                   MOVE      ZOUT20        LLLXPTA3
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCall - Call ZFRPED SubRoutine                               *
      *****************************************************************
     C     SRCall        BEGSR
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM      *BLANKS       ZOUT22
     C                   PARM      *BLANKS       ZOUT25
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialization SubRoutine                    *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PBJDFIN
     C                   PARM                    PBJCYCD
     C                   PARM                    BITPExFilFmt
     C                   PARM                    BITPExScnFmt
 
      ** Check Base Currency
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      PBJCYCD       @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
