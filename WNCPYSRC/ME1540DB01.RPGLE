      *---------------------------------------------------------------*
      *   Last Amend No. MD031937           Date 13Jan15              *
      *   Prev Amend No. AR856737           Date 13Sep11              *
      *                  ESL038             Date 01Oct2004            *
      *                  EEE058   *Create   Date 05Feb2003            *
      *---------------------------------------------------------------*
      *                                                               *
      *   MD031937 - Upgrade STP enhancements to BF Midas 2.1         *
      *   AR856737 - Upgrade STP enhancements to Midas Plus level     *
      *   ESL038 - ING STP Development                                *
      *   EEE058 - Incoming STP                                       *
      *                                                               *
      *---------------------------------------------------------------*
      *
      *                                                                                       EEE058
      ** Access SAR details file to determine if EEE058 is switched ON                        EEE058
      *                                                                                       EEE058
     C     EEE058        IFEQ      *BLANKS                                                    EEE058
     C                   CALL      'AOSARDR0'                                                 EEE058
     C                   PARM      *BLANKS       @RTCD             7                          EEE058
     C                   PARM      '*VERIFY'     @OPTN             7                          EEE058
     C                   PARM      'EEE058'      @SARD             6                          EEE058
     C     SCSARD        PARM      SCSARD        DSFDY                                        EEE058
      *                                                                                       EEE058
     C     @RTCD         IFEQ      *BLANKS                                                    EEE058
     C                   MOVEL     'EEE058'      EEE058            6                          EEE058
     C                   ELSE                                                                 EEE058
     C                   MOVEL     '*OFF  '      EEE058                                       EEE058
     C                   ENDIF                                                                EEE058
     C                   ENDIF                                                                EEE058
      *                                                                                       EEE058
     C     #2OPER        IFEQ      'CT'                                                       EEE058
     C                   MOVEL     *ON           *IN66                                        EEE058
     C                   ENDIF                                                                EEE058
      *
      *---------------------------------------------------------------*
      * copy hook end ME1540DB01                                      *
      *---------------------------------------------------------------*
