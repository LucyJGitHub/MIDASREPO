     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL RPIF File to Screen or Screen to File')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  DLRPIFCONV - Midas DL RPIF File to Screen or Screen to File  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 CSW214             Date 25Nov14               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CSW213 - SWIFT Change 2013                                   *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the FX standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** RPIF Link File Format
     D RILKFormat    E DS                  EXTNAME(DLRILKPD)
 
      ** RPIF Screen 1 Format
     D RPIFS1Format  E DS                  EXTNAME(DLRIS1PD)
 
      ** RPIF Screen 2 Format
     D RPIFS2Format  E DS                  EXTNAME(DLRIS2PD)
 
      ** RPIF Screen 3 Format
     D RPIFS3Format  E DS                  EXTNAME(DLRIS3PD)
                                                                                              CSW214
      ** RPIF Screen 4 Format                                                                 CSW214
     D RPIFS4Format  E DS                  EXTNAME(DLRIS4PD)                                  CSW214
 
      ** RPIF File Format
     D RPIFFormat    E DS                  EXTNAME(DLRPIFPD)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Action: '1' if File to file format, else '2'
     D Action          S              1A
 
      ** Variable for date
     D WR3Date         S              8A
                                                                                              CSW214
     D PrtCd           S              1A                                                      CSW214
     D CSW214          S              1A                                                      CSW214
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   IF        Action = '1'
      *
      ** Link file fields
      *
     C                   EVAL      RLAPID = RIAPID
      *
      ** Link file fields
      *
     C                   EVAL      RLTRRF = RITRRF
     C                   EVAL      RLBRCA = RIBRCA
     C                   EVAL      RLLTRF = RILNRF
     C                   EVAL      RLCNUM = RICPID
     C                   EVAL      RLDTYP = RIDTYP
     C                   EVAL      RLDLST = RIDLST
     C                   EVAL      RLFOID = RIFOID
     C                   EVAL      RLAFOI = RIAFOI
     C                   EVAL      RLACTN = RICHTP
     C                   EVAL      RLBCCY = RIBCCY
     C                   EVAL      RLSCCY = RISCCY
      *
      ** Screen 1 fields
      *
     C                   EVAL      R1TRID = RITRID
     C                   EVAL      R1CCPI = RICCPI
     C                   EVAL      R1CCPA = RICCPA
     C                   EVAL      R1CEPI = RICEPI
     C                   EVAL      R1CEPA = RICEPA
     C                   EVAL      R1CBIC = RICBCI
     C                   EVAL      R1CBIH = RICBPI
                                                                                              CSW214
      ** If SWIFT 2014 is installed                                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      R1CBRI = RICBRI                                            CSW214
     C                   EVAL      R1CBRA = RICBRA                                            CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   EVAL      R1CPID = RIPRID
     C                   EVAL      R1EXVE = RIEXVE
     C                   EVAL      R1UPID = RIUPID
     C                   EVAL      R1LSID = RILSID
      *
      ** Screen 2 fields
      *
     C                   EVAL      R2RPJ1 = RIRJ01
     C                   EVAL      R2RPP1 = RIRP01
     C                   EVAL      R2RPA1 = RIRA01
     C                   EVAL      R2RPN1 = RIRN01
     C                   EVAL      R2TRC1 = RIRC01
     C                   EVAL      R2RPS1 = RIRS01
     C                   EVAL      R2RPL1 = RIRL01
     C                   EVAL      R2UTI1 = RIUT01
     C                   EVAL      R2TRI1 = RITNI1
     C                   EVAL      R2TTY1 = RITIT1
     C                   EVAL      R2EVT1 = RIETT1
     C                   EVAL      R2RPJ2 = RIRJ02
     C                   EVAL      R2RPP2 = RIRP02
     C                   EVAL      R2RPA2 = RIRA02
     C                   EVAL      R2RPN2 = RIRN02
     C                   EVAL      R2TRC2 = RIRC02
     C                   EVAL      R2RPS2 = RIRS02
     C                   EVAL      R2RPL2 = RIRL02
     C                   EVAL      R2UTI2 = RIUT02
     C                   EVAL      R2TRI2 = RITNI2
     C                   EVAL      R2TTY2 = RITIT2
     C                   EVAL      R2EVT2 = RIETT2
     C                   EVAL      R2RPJ3 = RIRJ03
     C                   EVAL      R2RPP3 = RIRP03
     C                   EVAL      R2RPA3 = RIRA03
     C                   EVAL      R2RPN3 = RIRN03
     C                   EVAL      R2TRC3 = RIRC03
     C                   EVAL      R2RPS3 = RIRS03
     C                   EVAL      R2RPL3 = RIRL03
     C                   EVAL      R2UTI3 = RIUT03
     C                   EVAL      R2TRI3 = RITNI3
     C                   EVAL      R2TTY3 = RITIT3
     C                   EVAL      R2EVT3 = RIETT3
     C                   EVAL      R2RPJ4 = RIRJ04
     C                   EVAL      R2RPP4 = RIRP04
     C                   EVAL      R2RPA4 = RIRA04
     C                   EVAL      R2RPN4 = RIRN04
     C                   EVAL      R2TRC4 = RIRC04
     C                   EVAL      R2RPS4 = RIRS04
     C                   EVAL      R2RPL4 = RIRL04
     C                   EVAL      R2UTI4 = RIUT04
     C                   EVAL      R2TRI4 = RITNI4
     C                   EVAL      R2TTY4 = RITIT4
     C                   EVAL      R2EVT4 = RIETT4
      *
      ** Screen 3 fields
      *
     C                   EVAL      R3CTIN = RICGTI
     C                   EVAL      R3ALIN = RIALLI
     C                   EVAL      R3COIN = RICLLI
     C                   EVAL      R3NSFG = RINORS
                                                                                              CSW214
      ** If SWIFT 2014 is installed                                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      R3FNCI = RIFNCI                                            CSW214
     C                   EVAL      R3COPI = RICOPI                                            CSW214
     C                   EVAL      R3COPC = RICOPC                                            CSW214
     C                   EVAL      R3POCI = RIPOCI                                            CSW214
     C                   EVAL      R3COSI = RICOSI                                            CSW214
     C                   EVAL      R3TNEI = RITNEI                                            CSW214
     C                   EVAL      R3IGTI = RIIGTI                                            CSW214
     C                   EVAL      R3CTFI = RICTFI                                            CSW214
     C                   ENDIF                                                                CSW214
 
     C                   IF        RIGEDT = 0
     C                   EVAL      R3TSDT = *BLANKS
     C                   ELSE
 
     C                   IF        BJDFIN = 'D'
     C                   EVAL      R3TSDT = %CHAR(%DATE(RIGEDT: *ISO):*DMY0)
     C                   ELSE
     C                   EVAL      R3TSDT = %CHAR(%DATE(RIGEDT: *ISO):*MDY0)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        RIGETM = 0
     C                   EVAL      R3TSTM = *BLANKS
     C                   ELSE
     C                   MOVE      RIGETM        R3TSTM
     C                   ENDIF
 
     C                   EVAL      R3UTSS = RIUSGN
 
     C                   IF        RIUTCT = 0
     C                   EVAL      R3UTST = *BLANKS
     C                   ELSE
     C                   MOVE      RIUTCT        R3UTST
     C                   ENDIF
 
     C**********         EVAL      R3AR01 = RIAR01                                            CSW214
     C**********         EVAL      R3AR02 = RIAR02                                            CSW214
     C**********         EVAL      R3AR03 = RIAR03                                            CSW214
     C**********         EVAL      R3AR04 = RIAR04                                            CSW214
     C**********         EVAL      R3AR05 = RIAR05                                            CSW214
     C**********         EVAL      R3AR06 = RIAR06                                            CSW214
     C**********         EVAL      R3AR07 = RIAR07                                            CSW214
     C**********         EVAL      R3AR08 = RIAR08                                            CSW214
     C**********         EVAL      R3AR09 = RIAR09                                            CSW214
     C**********         EVAL      R3AR10 = RIAR10                                            CSW214
     C**********         EVAL      R3AR11 = RIAR11                                            CSW214
     C**********         EVAL      R3AR12 = RIAR12                                            CSW214
     C**********         EVAL      R3AR13 = RIAR13                                            CSW214
     C**********         EVAL      R3AR14 = RIAR14                                            CSW214
     C**********         EVAL      R3AR15 = RIAR15                                            CSW214
     C**********         EVAL      R3AR16 = RIAR16                                            CSW214
     C**********         EVAL      R3AR17 = RIAR17                                            CSW214
     C**********         EVAL      R3AR18 = RIAR18                                            CSW214
     C**********         EVAL      R3AR19 = RIAR19                                            CSW214
     C**********         EVAL      R3AR20 = RIAR20                                            CSW214
                                                                                              CSW214
      ** Screen 4 fields                                                                      CSW214
                                                                                              CSW214
     C                   EVAL      R4AR01 = RIAR01                                            CSW214
     C                   EVAL      R4AR02 = RIAR02                                            CSW214
     C                   EVAL      R4AR03 = RIAR03                                            CSW214
     C                   EVAL      R4AR04 = RIAR04                                            CSW214
     C                   EVAL      R4AR05 = RIAR05                                            CSW214
     C                   EVAL      R4AR06 = RIAR06                                            CSW214
     C                   EVAL      R4AR07 = RIAR07                                            CSW214
     C                   EVAL      R4AR08 = RIAR08                                            CSW214
     C                   EVAL      R4AR09 = RIAR09                                            CSW214
     C                   EVAL      R4AR10 = RIAR10                                            CSW214
     C                   EVAL      R4AR11 = RIAR11                                            CSW214
     C                   EVAL      R4AR12 = RIAR12                                            CSW214
     C                   EVAL      R4AR13 = RIAR13                                            CSW214
     C                   EVAL      R4AR14 = RIAR14                                            CSW214
     C                   EVAL      R4AR15 = RIAR15                                            CSW214
     C                   EVAL      R4AR16 = RIAR16                                            CSW214
     C                   EVAL      R4AR17 = RIAR17                                            CSW214
     C                   EVAL      R4AR18 = RIAR18                                            CSW214
     C                   EVAL      R4AR19 = RIAR19                                            CSW214
     C                   EVAL      R4AR20 = RIAR20                                            CSW214
 
     C                   ELSE
      *
      ** Link file fields
      *
     C                   EVAL      RIAPID = RLAPID
     C                   EVAL      RITRRF = RLTRRF
     C                   EVAL      RIBRCA = RLBRCA
     C                   EVAL      RILNRF = RLLTRF
     C                   EVAL      RICPID = RLCNUM
     C                   EVAL      RIDTYP = RLDTYP
     C                   EVAL      RIDLST = RLDLST
     C                   EVAL      RIFOID = RLFOID
     C                   EVAL      RIAFOI = RLAFOI
     C                   EVAL      RICHTP = RLACTN
     C                   EVAL      RIBCCY = RLBCCY
     C                   EVAL      RISCCY = RLSCCY
      *
      ** Screen 1 fields
      *
     C                   EVAL      RITRID = R1TRID
     C                   EVAL      RICCPI = R1CCPI
     C                   EVAL      RICCPA = R1CCPA
     C                   EVAL      RICEPI = R1CEPI
     C                   EVAL      RICEPA = R1CEPA
     C                   EVAL      RICBCI = R1CBIC
     C                   EVAL      RICBPI = R1CBIH
                                                                                              CSW214
      ** If SWIFT 2014 is installed                                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      RICBRI = R1CBRI                                            CSW214
     C                   EVAL      RICBRA = RICBRA                                            CSW214
     C                   ENDIF                                                                CSW214
      *                                                                                       CSW214
     C                   EVAL      RIPRID = R1CPID
     C                   EVAL      RIEXVE = R1EXVE
     C                   EVAL      RIUPID = R1UPID
     C                   EVAL      RILSID = R1LSID
      *
      ** Screen 2 fields
      *
     C                   EVAL      RIRJ01 = R2RPJ1
     C                   EVAL      RIRP01 = R2RPP1
     C                   EVAL      RIRA01 = R2RPA1
     C                   EVAL      RIRN01 = R2RPN1
     C                   EVAL      RIRC01 = R2TRC1
     C                   EVAL      RIRS01 = R2RPS1
     C                   EVAL      RIRL01 = R2RPL1
     C                   EVAL      RIUT01 = R2UTI1
     C                   EVAL      RITNI1 = R2TRI1
     C                   EVAL      RITIT1 = R2TTY1
     C                   EVAL      RIETT1 = R2EVT1
     C                   EVAL      RIRJ02 = R2RPJ2
     C                   EVAL      RIRP02 = R2RPP2
     C                   EVAL      RIRA02 = R2RPA2
     C                   EVAL      RIRN02 = R2RPN2
     C                   EVAL      RIRC02 = R2TRC2
     C                   EVAL      RIRS02 = R2RPS2
     C                   EVAL      RIRL02 = R2RPL2
     C                   EVAL      RIUT02 = R2UTI2
     C                   EVAL      RITNI2 = R2TRI2
     C                   EVAL      RITIT2 = R2TTY2
     C                   EVAL      RIETT2 = R2EVT2
     C                   EVAL      RIRJ03 = R2RPJ3
     C                   EVAL      RIRP03 = R2RPP3
     C                   EVAL      RIRA03 = R2RPA3
     C                   EVAL      RIRN03 = R2RPN3
     C                   EVAL      RIRC03 = R2TRC3
     C                   EVAL      RIRS03 = R2RPS3
     C                   EVAL      RIRL03 = R2RPL3
     C                   EVAL      RIUT03 = R2UTI3
     C                   EVAL      RITNI3 = R2TRI3
     C                   EVAL      RITIT3 = R2TTY3
     C                   EVAL      RIETT3 = R2EVT3
     C                   EVAL      RIRJ04 = R2RPJ4
     C                   EVAL      RIRP04 = R2RPP4
     C                   EVAL      RIRA04 = R2RPA4
     C                   EVAL      RIRN04 = R2RPN4
     C                   EVAL      RIRC04 = R2TRC4
     C                   EVAL      RIRS04 = R2RPS4
     C                   EVAL      RIRL04 = R2RPL4
     C                   EVAL      RIUT04 = R2UTI4
     C                   EVAL      RITNI4 = R2TRI4
     C                   EVAL      RITIT4 = R2TTY4
     C                   EVAL      RIETT4 = R2EVT4
      *
      ** Screen 3 fields
      *
     C                   EVAL      RICGTI = R3CTIN
     C                   EVAL      RIALLI = R3ALIN
     C                   EVAL      RICLLI = R3COIN
     C                   EVAL      RINORS = R3NSFG
                                                                                              CSW214
      ** If SWIFT 2014 is installed                                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      RIFNCI = R3FNCI                                            CSW214
     C                   EVAL      RICOPI = R3COPI                                            CSW214
     C                   EVAL      RICOPC = R3COPC                                            CSW214
     C                   EVAL      RIPOCI = R3POCI                                            CSW214
     C                   EVAL      RICOSI = R3COSI                                            CSW214
     C                   EVAL      RITNEI = R3TNEI                                            CSW214
     C                   EVAL      RIIGTI = R3IGTI                                            CSW214
     C                   EVAL      RICTFI = R3CTFI                                            CSW214
     C                   ENDIF                                                                CSW214
 
     C                   IF        R3TSDT = *BLANKS
     C                   Z-ADD     0             RIGEDT
     C                   ELSE
 
     C                   IF        BJDFIN = 'D'
     C     *DMY0         TEST (D)                R3TSDT                 99
 
     C                   IF        *IN99 = *OFF
     C                   EVAL      WR3Date = %CHAR(%DATE(R3TSDT: *DMY0):*ISO0)
     C                   ENDIF
 
     C                   ELSE
     C     *MDY0         TEST (D)                R3TSDT                 99
 
     C                   IF        *IN99 = *OFF
     C                   EVAL      WR3Date = %CHAR(%DATE(R3TSDT: *MDY0):*ISO0)
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     WR3Date       RIGEDT
     C                   ENDIF
 
     C                   IF        R3TSTM = *BLANKS
     C                   Z-ADD     0             RIGETM
     C                   ELSE
     C                   MOVE      R3TSTM        RIGETM
     C                   ENDIF
 
     C                   EVAL      RIUSGN = R3UTSS
 
     C                   IF        R3UTST = *BLANKS
     C                   Z-ADD     0             RIUTCT
     C                   ELSE
     C                   MOVE      R3UTST        RIUTCT
     C                   ENDIF
 
     C**********         EVAL      RIAR01 = R3AR01                                            CSW214
     C**********         EVAL      RIAR02 = R3AR02                                            CSW214
     C**********         EVAL      RIAR03 = R3AR03                                            CSW214
     C**********         EVAL      RIAR04 = R3AR04                                            CSW214
     C**********         EVAL      RIAR05 = R3AR05                                            CSW214
     C**********         EVAL      RIAR06 = R3AR06                                            CSW214
     C**********         EVAL      RIAR07 = R3AR07                                            CSW214
     C**********         EVAL      RIAR08 = R3AR08                                            CSW214
     C**********         EVAL      RIAR09 = R3AR09                                            CSW214
     C**********         EVAL      RIAR10 = R3AR10                                            CSW214
     C**********         EVAL      RIAR11 = R3AR11                                            CSW214
     C**********         EVAL      RIAR12 = R3AR12                                            CSW214
     C**********         EVAL      RIAR13 = R3AR13                                            CSW214
     C**********         EVAL      RIAR14 = R3AR14                                            CSW214
     C**********         EVAL      RIAR15 = R3AR15                                            CSW214
     C**********         EVAL      RIAR16 = R3AR16                                            CSW214
     C**********         EVAL      RIAR17 = R3AR17                                            CSW214
     C**********         EVAL      RIAR18 = R3AR18                                            CSW214
     C**********         EVAL      RIAR19 = R3AR19                                            CSW214
     C**********         EVAL      RIAR20 = R3AR20                                            CSW214
                                                                                              CSW214
      ** Screen 4 fields                                                                      CSW214
                                                                                              CSW214
     C                   EVAL      RIAR01 = R4AR01                                            CSW214
     C                   EVAL      RIAR02 = R4AR02                                            CSW214
     C                   EVAL      RIAR03 = R4AR03                                            CSW214
     C                   EVAL      RIAR04 = R4AR04                                            CSW214
     C                   EVAL      RIAR05 = R4AR05                                            CSW214
     C                   EVAL      RIAR06 = R4AR06                                            CSW214
     C                   EVAL      RIAR07 = R4AR07                                            CSW214
     C                   EVAL      RIAR08 = R4AR08                                            CSW214
     C                   EVAL      RIAR09 = R4AR09                                            CSW214
     C                   EVAL      RIAR10 = R4AR10                                            CSW214
     C                   EVAL      RIAR11 = R4AR11                                            CSW214
     C                   EVAL      RIAR12 = R4AR12                                            CSW214
     C                   EVAL      RIAR13 = R4AR13                                            CSW214
     C                   EVAL      RIAR14 = R4AR14                                            CSW214
     C                   EVAL      RIAR15 = R4AR15                                            CSW214
     C                   EVAL      RIAR16 = R4AR16                                            CSW214
     C                   EVAL      RIAR17 = R4AR17                                            CSW214
     C                   EVAL      RIAR18 = R4AR18                                            CSW214
     C                   EVAL      RIAR19 = R4AR19                                            CSW214
     C                   EVAL      RIAR20 = R4AR20                                            CSW214
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
     C                   PARM                    Action
     C                   PARM                    RILKFormat
     C                   PARM                    RPIFS1Format
     C                   PARM                    RPIFS2Format
     C                   PARM                    RPIFS3Format
     C                   PARM                    RPIFS4Format                                 CSW214
     C                   PARM                    RPIFFormat
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                              CSW214
      ** Check if SWIFT 2014 feature is installed                                             CSW214
                                                                                              CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PrtCd                                        CSW214
                                                                                              CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   IF        PrtCd   = 'CSW2014'                                        CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   ENDIF                                                                CSW214
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
