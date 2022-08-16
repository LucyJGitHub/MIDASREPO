     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Change Details - Write')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUCDWRT - Audit Change Details - Write                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. AR958473           Date 16Oct12               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR958473 - Incorrect values in GPAUCHPD, field AHUSER.       *
      *             Parameters changed in GPAUEXT. Use the timestamp  *
      *             field to retrieve the correct transaction.        *
      *             (Child: AR958477)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAUCDPD  O    E             DISK    INFSR(*PSSR)
 
      *                                                                                     AR958473
      ** Field declaration for Date and time operations.                                    AR958473
      *                                                                                     AR958473
     DI#TIMZ           S               Z                                                    AR958473
     DJ#YEAR           S              4  0                                                  AR958473
     DConv_InDATE      S              6  0                                                  AR958473
     D                 DS                                                                   AR958473
     D YYYY                    1      4                                                     AR958473
     D YY1                     1      2  0                                                  AR958473
     D YY2                     3      4  0                                                  AR958473
     D                 DS                                                                   AR958473
     D YYMMDD                  1      6                                                     AR958473
     D YY                      1      2  0                                                  AR958473
     D MM                      3      4  0                                                  AR958473
     D DD                      5      6  0                                                  AR958473
 
      * Field Attributes
      * Field Shortnames
      * Field Action Selection
     D/COPY GPCPYSRCG,GPAUFDATB
     D/COPY GPCPYSRCG,GPAUFDSNM
     D/COPY GPCPYSRCG,GPAUFDASL
 
 
      * Field Contents
     D/COPY GPCPYSRCG,GPAUFDCON
 
 
     D                 DS
     D OUTPUT                  1    111
     D OUT                     1    111    DIM(111)
 
 
     D                 DS
     D A_DATA                  1  25600    DIM(25600)
     D A_DTA                   1  25600    DIM(100)
     D                 DS
     D B_DATA                  1  25600    DIM(25600)
     D B_DTA                   1  25600    DIM(100)
 
     D                 DS
     D  w#cr                   1      1    inz(x'0d')
     D  w#lf                   2      2    inz(x'25')
 
 
      * Reference ID SubFields & Sizes
     D REFSF           S            100    DIM(9)
     D REFSFSZ         S              4S 0 DIM(9)
 
 
      * Initialize outputs
 
     C                   MOVEL     *BLANK        Branch
     C                   MOVEL     *BLANK        ReferID
     C                   MOVEL     *BLANK        Action
     C                   MOVE      'N'           RecordsWritten
 
      * Clear Reference ID SubFields & Sizes
 
     C                   Clear                   REFSF
     C                   Clear                   REFSFSZ
 
      *                                                                                     AR958473
      ** Extract date from the journal timestamp field                                      AR958473
      ** The CONVERT_INDAT SR will not be used anymore since                                AR958473
      ** conversion is also done in EXTRCT_DATE SR.                                         AR958473
      *                                                                                     AR958473
     C                   EXSR      EXTRCT_DATE                                              AR958473
     C*                                                                                     AR958473
      **Convert*In*Date*to*YYMMDD*format******************************                      AR958473
 
     C**********         EXSR      CONVERT_INDAT                                            AR958473
 
      * Zone
     C                   MOVEL     I#ZONE        ADZONE
      * ID
     C                   Z-ADD     I#SEQN        ADCID
     C                   MOVEL     Conv_InDATE   ADCID
 
      * Output PUTS
      * Output DELETES
      * Output UPDATES
 
     C                   SELECT
     C     I#ENTT        WHENEQ    'PT'
     C                   EXSR      OUTPUT_PT
     C     I#ENTT        WHENEQ    'DL'
     C                   EXSR      OUTPUT_DL
     C                   OTHER
     C                   EXSR      OUTPUT_UP
     C                   ENDSL
 
      * Determine Reference ID
 
     C                   EXSR      DET_REFID
 
      * Determine field selection values
 
     C                   EXSR      DET_FDACSLVL
 
      * Determine Action
 
     C                   MOVEL     'APPROVE     'Action
     C                   EXSR      DET_ACTION
     C     Select_Action IFNE      'Y'
     C                   MOVEL     'AUTHORIZE   'Action
     C                   EXSR      DET_ACTION
     C     Select_Action IFNE      'Y'
     C                   MOVEL     'DELETE      'Action
     C                   EXSR      DET_ACTION
     C     Select_Action IFNE      'Y'
     C                   SELECT
     C     I#ENTT        WHENEQ    'PT'
     C                   MOVEL     'INSERT    '  Action
     C     I#ENTT        WHENEQ    'DL'
     C                   MOVEL     'DELETE    '  Action
     C                   OTHER
     C                   MOVEL     'AMEND     '  Action
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Return
 
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      **Convert*In*Date*to*YYMMDD*format******************************                      AR958473
      **(In*Date*is*in*DDMMYY*format)*********************************                      AR958473
      ********************************************************************                  AR958473
     C*****CONVERT_INDAT BEGSR                                                              AR958473
      **********                                                                            AR958473
     C**********         MOVEL     I#DATE        Work40            4 0                      AR958473
     C**********         MOVEL     Work40        Day               2 0                      AR958473
     C**********         MOVE      Work40        Month             2 0                      AR958473
     C**********         MOVEL     Month         Work40                                     AR958473
     C**********         MOVE      Day           Work40                                     AR958473
     C**********         MOVE      Work40        Conv_InDATE       6 0                      AR958473
      **********                                                                            AR958473
     C**********         MOVE      I#DATE        Year              2 0                      AR958473
     C**********         MOVEL     Year          Conv_InDATE                                AR958473
      **********                                                                            AR958473
     C**********         ENDSR                                                              AR958473
      ********************************************************************
     C/SPACE 5
      ****************************************************************
      * Output PUTS
      ****************************************************************
     C     OUTPUT_PT     BEGSR
 
     C                   MOVE      *BLANK        A_DATA
 
      * Add all fields to the AFTER data buffer
 
     C                   Z-ADD     1             #FD               5 0
     C                   Z-ADD     1             #AO               5 0
     C     #FD           DOWLE     250
     C     #_FDATRB(#FD) ANDNE     *BLANK
     C                   MOVEL     #_FDATRB(#FD) #FDATRB
     C                   EXSR      UPD_REFSF
     C                   EXSR      UPD_BRANCH
     C     #_FDCON(#FD)  IFNE      *BLANK
     C                   EVAL      OUTPUT  = %TRIMR(AFSNAM) + w#cr
     C                                       + #_FDCON(#FD)
     C     ' '           CHECKR    OUTPUT        #L                3 0
     C                   ADD       1             #L
     C                   MOVEL     w#lf          OUT(#L)
     C                   MOVEA     OUT           A_DATA(#AO)
     C                   ADD       #L            #AO
     C                   ENDIF
     C                   ADD       1             #FD
     C                   ENDDO
 
      *  Write records
      *  -------------
 
      * Write the AFTER data buffer in blocks of 256 bytes
     C                   MOVEL     'A'           ADBFAF
 
     C                   Z-ADD     1             #AO
     C     #AO           DOWLE     100
     C     A_DTA(#AO)    ANDNE     *BLANK
     C                   Z-ADD     #AO           ADSEQN
     C                   MOVEL     A_DTA(#AO)    ADDATA
     C                   WRITE     GPAUCDD0
     C                   ADD       1             #AO
     C                   EVAL      RecordsWritten = 'Y'
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
     C/SPACE 5
      ****************************************************************
      * Output DELETES
      ****************************************************************
     C     OUTPUT_DL     BEGSR
 
     C                   MOVE      *BLANK        B_DATA
 
      * Add all fields to the BEFORE data buffer
 
     C                   Z-ADD     1             #FD
     C                   Z-ADD     1             #BO               5 0
     C     #FD           DOWLE     250
     C     #_FDATRB(#FD) ANDNE     *BLANK
     C                   MOVEL     #_FDATRB(#FD) #FDATRB
     C                   EXSR      UPD_REFSF
     C                   EXSR      UPD_BRANCH
     C     #B_FDCON(#FD) IFNE      *BLANK
     C                   EVAL      OUTPUT  = %TRIMR(AFSNAM) + w#cr
     C                                       + #B_FDCON(#FD)
     C     ' '           CHECKR    OUTPUT        #L
     C                   ADD       1             #L
     C                   MOVEL     w#lf          OUT(#L)
     C                   MOVEA     OUT           B_DATA(#BO)
     C                   ADD       #L            #BO
     C                   ENDIF
     C                   ADD       1             #FD
     C                   ENDDO
 
      *  Write records
      *  -------------
 
      * Write the BEFORE data buffer in blocks of 256 bytes
     C                   MOVEL     'B'           ADBFAF
 
     C                   Z-ADD     1             #BO
     C     #BO           DOWLE     100
     C     B_DTA(#BO)    ANDNE     *BLANK
     C                   Z-ADD     #BO           ADSEQN
     C                   MOVEL     B_DTA(#BO)    ADDATA
     C                   WRITE     GPAUCDD0
     C                   ADD       1             #BO
     C                   EVAL      RecordsWritten = 'Y'
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
     C/SPACE 5
      ****************************************************************
      * Output UPDATES
      ****************************************************************
     C     OUTPUT_UP     BEGSR
 
     C                   MOVE      *BLANK        A_DATA
     C                   MOVE      *BLANK        B_DATA
 
     C                   MOVE      'N'           ChangedData       1
 
      * Add all fields to the BEFORE and AFTER data buffer
 
     C                   Z-ADD     1             #FD               5 0
     C                   Z-ADD     1             #AO               5 0
     C                   Z-ADD     1             #BO               5 0
     C     #FD           DOWLE     250
     C     #_FDATRB(#FD) ANDNE     *BLANK
     C                   MOVEL     #_FDATRB(#FD) #FDATRB
     C                   EXSR      UPD_REFSF
     C                   EXSR      UPD_BRANCH
      * if before<>after
      *  before
     C     #B_FDCON(#FD) IFNE      #_FDCON(#FD)
     C                   EVAL      ChangedData = 'Y'
     C                   EVAL      OUTPUT  = %TRIMR(AFSNAM) + w#cr
     C                                       + #B_FDCON(#FD)
     C     ' '           CHECKR    OUTPUT        #L
     C                   ADD       1             #L
     C                   MOVEL     w#lf          OUT(#L)
     C                   MOVEA     OUT           B_DATA(#BO)
     C                   ADD       #L            #BO
     C                   ENDIF
      * after
     C     #_FDCON(#FD)  IFNE      *BLANK
     C                   EVAL      OUTPUT  = %TRIMR(AFSNAM) + w#cr
     C                                       + #_FDCON(#FD)
     C     ' '           CHECKR    OUTPUT        #L
     C                   ADD       1             #L
     C                   MOVEL     w#lf          OUT(#L)
     C                   MOVEA     OUT           A_DATA(#AO)
     C                   ADD       #L            #AO
     C                   ENDIF
     C                   ADD       1             #FD
     C                   ENDDO
 
      *  Write records
      *  -------------
 
      * Write the BEFORE data buffer in blocks of 256 bytes
     C                   MOVEL     'B'           ADBFAF
 
     C                   Z-ADD     1             #BO
     C     #BO           DOWLE     100
     C     B_DTA(#BO)    ANDNE     *BLANK
     C                   Z-ADD     #BO           ADSEQN
     C                   MOVEL     B_DTA(#BO)    ADDATA
     C                   WRITE     GPAUCDD0
     C                   ADD       1             #BO
     C                   EVAL      RecordsWritten = 'Y'
     C                   ENDDO
 
      * If there is changed data
      * Write the AFTER data buffer in blocks of 256 bytes
 
     C     ChangedData   IFEQ      'Y'
     C                   MOVEL     'A'           ADBFAF
 
     C                   Z-ADD     1             #AO
     C     #AO           DOWLE     100
     C     A_DTA(#AO)    ANDNE     *BLANK
     C                   Z-ADD     #AO           ADSEQN
     C                   MOVEL     A_DTA(#AO)    ADDATA
     C                   WRITE     GPAUCDD0
     C                   ADD       1             #AO
     C                   EVAL      RecordsWritten = 'Y'
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Reference ID Sub-Fields
      ********************************************************************
     C     UPD_REFSF     BEGSR
 
     C     AFREFF        IFNE      *BLANK
     C                   MOVEL     AFREFF        SQ_RF             1 0
     C     I#ENTT        IFEQ      'DL'
     C                   MOVEL     #B_FDCON(#FD) REFSF(SQ_RF)
     C                   ELSE
     C                   MOVEL     #_FDCON(#FD)  REFSF(SQ_RF)
     C                   ENDIF
     C                   Z-ADD     AFEDTS        REFSFSZ(SQ_RF)
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Branch Field
      ********************************************************************
     C     UPD_BRANCH    BEGSR
 
     C     AFBRCF        IFNE      *BLANK
     C     I#ENTT        IFEQ      'DL'
     C                   MOVEL     #B_FDCON(#FD) Branch
     C                   ELSE
     C                   MOVEL     #_FDCON(#FD)  Branch
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Determine Reference ID
      ********************************************************************
     C     DET_REFID     BEGSR
 
      * Step through Reference ID Sub-Fields
      * to create the Reference ID
 
     C                   Z-ADD     1             RIDPtr            4 0
     C                   Z-ADD     *ZERO         SQ_RF
     C                   MOVEL     *BLANK        FullReferID     140
 
     C     SQ_RF         DOUEQ     9
 
     C                   ADD       1             SQ_RF
 
     C                   MOVEL     REFSF(SQ_RF)  FieldDta        100
     C                   Z-ADD     REFSFSZ(SQ_RF)FieldSiz          4 0
 
     C     FieldSiz      ifne      *ZERO
     C     RIDPtr        andle     40
     C                   EVAL      %subst(FullReferID:RIDPtr:FieldSiz) =
     C                               %subst(FieldDta:1:FieldSiz)
     C                   EVAL      RIDPtr = RIDPtr + FieldSiz
     C                   endif
 
     C                   ENDDO
 
     C                   MOVEL     FullReferID   ReferID
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ****************************************************************
      * Determine field action selection values
      ****************************************************************
     C     DET_FDACSLVL  BEGSR
 
     C                   Z-ADD     1             #FS               5 0
     C     #FS           DOWLE     150
     C     #_FDACSL(#FS) ANDNE     *BLANK
     C                   MOVEL     #_FDACSL(#FS) #FDACSL
     C                   Z-ADD     1             #FD
     C     AFSFLD        LOOKUP    #_FDSNAM(#FD)                          99    *
     C     *IN99         IFEQ      *ON
     C     AFBFAF        IFEQ      'B'
     C                   MOVEL     #B_FDCON(#FD) Fld_Value
     C                   ELSE
     C                   MOVEL     #_FDCON(#FD)  Fld_Value
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     #FDACSL       #_FDACSL(#FS)
     C                   ADD       1             #FS
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
     C/SPACE 5
      ********************************************************************
      * Determine action
      ********************************************************************
     C     DET_ACTION    BEGSR
 
     C                   Z-ADD     1             #FS
     C                   Z-ADD     *ZERO         No_VCmps          5 0
     C                   Z-ADD     *ZERO         No_Cmps           5 0
 
     C                   MOVEL     'N'           Select_Action     1
 
     C     #FS           DOWLE     150
     C     #_FDACSL(#FS) ANDNE     *BLANK
 
     C                   MOVEL     #_FDACSL(#FS) #FDACSL
 
     C     AFACTN        IFEQ      Action
 
     C     AFSIAO        IFEQ      'IF '
     C     AFSIAO        OREQ      'OR '
     C     No_VCmps      IFNE      *ZERO
     C     No_VCmps      ANDEQ     No_Cmps
     C                   MOVEL     'Y'           Select_Action
     C                   LEAVE
     C                   ENDIF
     C                   Z-ADD     *ZERO         No_VCmps
     C                   Z-ADD     *ZERO         No_Cmps
     C                   ENDIF
 
     C                   SELECT
     C     AFSCMP        WHENEQ    'EQ'
     C     Fld_Value     COMP      AFSCPV                                 99    *
     C     AFSCMP        WHENEQ    'NE'
     C     Fld_Value     COMP      AFSCPV                             9999      *
     C     AFSCMP        WHENEQ    'GT'
     C     Fld_Value     COMP      AFSCPV                             99        *
     C     AFSCMP        WHENEQ    'GE'
     C     Fld_Value     COMP      AFSCPV                             99  99    *
     C     AFSCMP        WHENEQ    'LT'
     C     Fld_Value     COMP      AFSCPV                               99      *
     C     AFSCMP        WHENEQ    'LE'
     C     Fld_Value     COMP      AFSCPV                               9999    *
     C                   ENDSL
 
     C   99              ADD       1             No_VCmps          5 0
     C                   ADD       1             No_Cmps           5 0
 
     C                   ENDIF
 
     C                   ADD       1             #FS
     C                   ENDDO
 
     C     No_VCmps      IFNE      *ZERO
     C     No_VCmps      ANDEQ     No_Cmps
     C                   MOVEL     'Y'           Select_Action
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************                  AR958473
      * Extract Year, Month and Day portion from journal Timestamp                          AR958473
      ********************************************************************                  AR958473
     C     EXTRCT_DATE   BEGSR                                                              AR958473
      *                                                                                     AR958473
     C                   EVAL      J#YEAR = %SUBDT(I#TIMZ:*Y)                               AR958473
     C                   MOVE      J#YEAR        YYYY                                       AR958473
     C                   EVAL      YY = %REM(%SUBDT(I#TIMZ:*Y):100)                         AR958473
     C                   EVAL      MM = %SUBDT(I#TIMZ:*M)                                   AR958473
     C                   EVAL      DD = %SUBDT(I#TIMZ:*D)                                   AR958473
     C                   MOVE      YYMMDD        Conv_InDATE                                AR958473
      *                                                                                     AR958473
     C                   ENDSR                                                              AR958473
      ********************************************************************                  AR958473
      /SPACE 5                                                                              AR958473
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
      * Zone
      * Journal Sequence Number
      * Journal Timestamp                                                                   AR958473
      **Journal*Date**************************************************                      AR958473
      * Journal Entry Type
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#SEQN           10 0
     C                   PARM                    I#TIMZ                                     AR958473
     C**********         PARM                    I#DATE            6                        AR958473
     C                   PARM                    I#ENTT            2
      * Field Attributes
      * Field Shortnames
      * Field Action Selection
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
     C                   PARM                    #_FDACSL
      * Field Contents
     C                   PARM                    #_FDCON
     C                   PARM                    #B_FDCON
      * OUTPUT
      * Branch
      * Reference ID
      * Action
     C                   PARM                    Branch            3
     C                   PARM                    ReferID          40
     C                   PARM                    Action           10
      * Records Written
     C                   PARM                    RecordsWritten    1
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
