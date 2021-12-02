nwbNN = nwbRead('MW4_Session_3_filter.nwb')

%%


nwbEvents = types.core.AnnotationSeries('data', num2str(eventRecon.TTL),...
    'data_unit', 'NA', 'timestamps', eventRecon.TS, 'description', 'TTLs');


nwbNN.acquisition.set('events', nwbEvents)


%%

nwbExport(nwbNN,'MW4_Session_3_filter.nwb')